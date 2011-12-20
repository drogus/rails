require 'abstract_unit'

class RequestIdTest < ActiveSupport::TestCase
  test "include original PATH_INFO" do
    assert_equal "/foo/", stub_request('PATH_INFO' => '/foo/').original_path
  end

  test "include SCRIPT_NAME" do
    env = {
      'SCRIPT_NAME' => '/foo',
      'PATH_INFO' => '/bar'
    }
    assert_equal "/foo/bar", stub_request(env).original_path
  end

  test "include QUERY_STRING" do
    env = {
      'PATH_INFO' => '/foo',
      'QUERY_STRING' => 'bar',
    }
    assert_equal "/foo?bar", stub_request(env).original_path
  end

  private

  def stub_request(env = {})
    ActionDispatch::OriginalPath.new(lambda { |environment| [ 200, environment, [] ] }).call(env)
    ActionDispatch::Request.new(env)
  end
end
