#!ruby -Ks
# DXRubyExtensionサンプル
require "dxruby"
require "dxrubyex"
#require './hitrangeview' # 衝突判定範囲描画ライブラリ。HitRange.view(Collision配列)で衝突判定範囲が黄色で見える。

# 衝突判定配列
# ここに判定オブジェクトをたくさん入れる
$collisions = []

# 動くもの共通クラス
class CollisionObject
  def initialize
    @x = rand(639-@image1.width)
    @y = rand(439-@image1.height)
    @hit = false
    @dx = (rand(4)*2-3)/2.0
    @dy = (rand(4)*2-3)/2.0
  end

  # キャラ移動と判定配列設定
  def update
    @x += @dx
    @y += @dy
    @dx = -@dx if @x <= 0 or @x >= 639-@image1.width
    @dy = -@dy if @y <= 0 or @y >= 479-@image1.height

    # setメソッドで判定オブジェクトの位置を移動する
    @collision.set(@x, @y)
    # 配列にpush
    $collisions.push(@collision)
    @hit = false
  end

  def draw
    if @hit then
      Window.draw(@x, @y, @image2)
    else
      Window.draw(@x, @y, @image1)
    end
  end

  # あたっていたらhitが呼ばれる
  def hit(d)
    @hit = true
  end
end

# しかく
class Box < CollisionObject
  def initialize
    # 衝突判定オブジェクト作成。
    # 第一引数のオブジェクトのhitメソッドが呼ばれる。
    # 第二以降の引数は判定範囲の指定。原点はキャラの座標。
    # setメソッドで移動させるから、判定範囲は変更する必要がない。
    @collision = CollisionBox.new(self, 0, 0, 29, 29)
    @image1 = Image.new(30, 30, [255, 200, 0, 0])
    @image2 = Image.new(30, 30, [255, 200, 200, 200])
    super
  end
end

# まる
class Circle < CollisionObject
  def initialize
    # 円の場合は中心座標と半径を指定する。
    @collision = CollisionCircle.new(self, 20, 20, 20)
    @image1 = Image.new(41, 41).circleFill(20, 20, 20, [255, 0, 0, 200])
    @image2 = Image.new(41, 41).circleFill(20, 20, 20, [255, 200, 200, 200])
    super
  end
end

# さんかく
class Triangle < CollisionObject
  def initialize
    # 三角は3点の座標を指定する。
    @collision = CollisionTriangle.new(self, 20,0,0,39,39,39)
    @image1 = Image.new(40, 40)
    @image2 = Image.new(40, 40)
    for i in 0..39
      @image1.line(20-i/2, i, 20+i/2, i, [255,0,200,0])
      @image2.line(20-i/2, i, 20+i/2, i, [255,200,200,200])
    end
    super
  end
end

font = Font.new(24)

# 移動＆描画するモノの配列。20個ずつ作る。
object = Array.new(30) {Box.new} +
         Array.new(30) {Circle.new} +
         Array.new(30) {Triangle.new}

# メインループ
Window.loop do
  # 移動＆判定オブジェクトの配列へのpush
  object.each do |o|
    o.update
  end

  # マウスカーソルの座標をセットした点判定オブジェクト。
  # 第一引数にnilを指定すると衝突通知が行われない。
  mousecollision = CollisionPoint.new(nil)
  mousecollision.set(Input.mousePosX, Input.mousePosY)

  # マウスカーソルとオブジェクトの衝突判定。
  # 単体の場合は配列である必要はない。
  Collision.check(mousecollision, $collisions)

  # オブジェクト同士の衝突判定。
  Collision.check($collisions, $collisions)

  # 衝突判定範囲の可視化
#  HitRange.view($collisions)

  # 判定配列をクリアする。
  $collisions.clear

  # 描画
  object.each do |o|
    o.draw
  end

  break if Input.keyPush?(K_ESCAPE)

  Window.drawFont(0, 0, Window.fps.to_s + " fps", font)
  Window.drawFont(0, 24, Window.getLoad.to_i.to_s + " %", font)
end
