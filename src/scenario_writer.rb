# -*- coding: utf-8 -*-
require 'ostruct'
require './src/active_object/enemy'


lambda do
  enemies_bench = []

  Kernel.send :define_method, :read_enemies_from_database do |level|
    enemies_bench.clear

    file_path = "./scenario/level_#{level}.rb"
    load file_path if File.exist? file_path

    enemies_bench.sort { |a, b| a.time <=> b.time }
  end

  [ :Red, :Blue, :Yellow, :Green ].each do |name|
    Kernel.send :define_method, name do |time, *param|
      obj = OpenStruct.new

      obj.time = time

      # いちいちScenario側でPoint.newするのが面倒くさいから。
      point = Point.new( param[0], param[1] )
      obj.enemy = eval "#{name}Enemy.new point, *param[2..param.size]", binding

      enemies_bench << obj
    end
  end
end.call
