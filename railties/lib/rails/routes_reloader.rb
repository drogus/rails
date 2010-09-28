module Rails
  class RoutesReloader
    attr_accessor :file_checker

    def initialize
      self.file_checker = ActiveSupport::FileUpdateChecker.new([]){ reload! }
    end

    def blocks
      @blocks ||= {}
    end

    def paths
      file_checker.paths
    end

    def execute_if_updated
      file_checker.execute_if_updated
    end
  private
    def reload!
      clear!
      load_blocks
      load_paths
      finalize!
    ensure
      revert
    end

    def clear!
      routers.each do |routes|
        routes.disable_clear_and_finalize = true
        routes.clear!
      end
    end

    def load_blocks
      blocks.each do |routes, block|
        routes.draw(&block) if block
      end
    end

    def load_paths
        paths.each { |path| load(path) }
    end

    def finalize!
      routers.each do |routes|
        ActiveSupport.on_load(:action_controller) { routes.finalize! }
      end
    end

    def revert
      routers.each do |routes|
        routes.disable_clear_and_finalize = false
      end
    end

    def routers
      blocks.keys
    end
  end
end

