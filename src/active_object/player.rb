# -*- coding: utf-8 -*-
require './src/stdlib'
require './src/active_object/active_object'


class Player < ActiveObject
  # 発射した弾丸をPlay#bulletsに渡すラムダを引数に持つ
  def initialize(shoot_bullet)
    super $conf.player_init_point, Vector2.new

    @life = 1000
    @angle = Vector2.new(0, 1)
    @max_velocity = 8
    @bullet_velocity = 10
    @accel = 0.94

    @shoot_bullet = shoot_bullet

    $conf.draw_gap = $conf.show_area_center - @point

    add_animation :fight, 1, [0], :fight
    start_animation :fight
  end

  def move
    # velocity
    @velocity += Input
    @velocity.size = min(@velocity.size, @max_velocity / @accel)
    @velocity.size *= @accel

    # point
    @point += @velocity
    llimit = Point.new(self.image.width,self.image.height)*0.5
    ulimit = $conf.active_field - Point.new(self.image.width,self.image.height)*1.5
    @point = Point.catch(llimit, @point, ulimit)

    # angle
    angle = @velocity.dup; angle.size = 1
    @angle = angle if angle.size != 0
    self.angle = Math.atan2(@angle.y, @angle.x) / Math.PI * 180 + 90

    # outer settings
    $player_pnt = @point
    $conf.draw_gap = $conf.show_area_center - $player_pnt
    $conf.draw_gap.x = range(-1280, $conf.draw_gap.x, 0)
    $conf.draw_gap.y = range(-960, $conf.draw_gap.y, 0)
  end

  def fire
    self.nomal_fire if Input.key_down? K_Z
    self.spiral_fire if Input.key_down? K_X
  end

  def nomal_fire
    position = @point + @angle * 50
    position.x += @@image.width / 2
    position.y += @@image.height / 2

    @shoot_bullet.call Bullet.new(position, @angle * @bullet_velocity)
  end

  def spiral_fire
    base_point = @point + Point.new(@@image.width / 2, @@image.height / 2)

    20.times do |i|
      angle = Vector2.polar(i * 2.0 * Math.PI / num, 1.0)
      point = base_point + direc * 50
      @shoot_bullet.call Bullet.new(point, angle * @bullet_velocity)
    end

    @life -= 10
    self.vanish if @life <= 0
  end

  def hit(other)
    @life -= 1

    self.vanish if @life <= 0
  end


  @@image = Image.load('./img/player.png')
  def init
    self.collision = [[18, 0, 0, 30, 36, 30], [18, 58, 19, 30, 28, 30]]
    self.animation_image = [@@image]
  end
end


class Bullet < ActiveObject
  def initialize(point, velocity)
    super point, velocity

    add_animation :exit, 1, (0..7).to_a, :vanish
    add_animation :fight, 1, [0], :fight
    start_animation :fight, [@@image]
  end

  @@image = Image.load('./img/bullet.png')
  @@exit_image = Image.load_tiles("./img/pipo-btleffect008.png", 8, 1)
  def init
    self.collision = [ 11, 11, 11 ]
    self.animation_image = [@@image]
  end

  def out(other=nil)
    self.fighting = false
    start_animation :exit, @@exit_image
  end
end
