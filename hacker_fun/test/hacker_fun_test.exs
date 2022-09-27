defmodule HackerFunTest do
  use ExUnit.Case
  doctest HackerFun

  test "greets the world" do
    assert HackerFun.hello() == :world
  end
end
