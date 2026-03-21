# L * omega = 1 / (omega * C)

using Luxor

# include(dirname(pathof(Luxor)) * "/play.jl")

const LInd = 980
const CCap = 0.00005
const UVolt = 80
UCond = UVolt
Q = CCap * UVolt
omega = 1 / sqrt(LInd * CCap)
period = (2 * pi) / omega
print(period)

q = t -> Q * cos(omega * t); # derives from differential equation of an LC-circuit
I = t -> omega * Q * sin(omega * t)
dI = t -> omega * omega * Q * cos(omega * t)

const WI = 1200
const HE = 800
const MA = 50
const STX = 250
const STY = 1800
const CIRCUITWIDTH = 400
const CIRCUITHEIGHT = 400

function drawAxis()
    sethue("black")
    fontsize(20)
    text("Änderung der Stromstärke dI/dt", 30, -HE / 2 + MA + 20)
    line(Point(-MA, 0), Point(period * STX + MA, 0))
    line(Point(0, -HE / 2 + MA), Point(0, HE / 2 - MA))
    strokepath()
    fontsize(15)
    for i in 0:0.2:(trunc(period * 5)*0.2+0.2)
        circle(Point(0 + i * STX, 0), 3, :fill)
        text(string(round(i, digits=1)), Point(0 + i * STX - 7, 0 + 15))
    end
    circle(Point(0, -STY * omega * omega * Q), 3, :fill)
    text(join([string(round((omega * omega * Q); digits=3)), " C/s^2"]), Point(12, -STY * omega * omega * Q))
end

function drawCircuit()
    sethue("black")
    move(Point(WI - MA - MA - 40 - CIRCUITWIDTH, -10))
    line(Point(WI - MA - MA - 40 - CIRCUITWIDTH + 30, -10))
    line(Point(WI - MA - MA - 40 - CIRCUITWIDTH - 30, -10))
    move(Point(WI - MA - MA - 40 - CIRCUITWIDTH, -10))
    line(Point(WI - MA - MA - 40 - CIRCUITWIDTH, -CIRCUITHEIGHT / 2))
    move(Point(WI - MA - MA - 40 - CIRCUITWIDTH, -CIRCUITHEIGHT / 2))
    line(Point(WI - MA - MA - 40, -CIRCUITHEIGHT / 2))
    move(Point(WI - MA - MA - 40, -CIRCUITHEIGHT / 2))
    line(Point(WI - MA - MA - 40, -30))
    move(Point(WI - MA - MA - 40, -30))
    for i in -30:10:20
        arc2r(Point(WI - MA - MA - 40 + 8, i + 5), Point(WI - MA - MA - 40, i), Point(WI - MA - MA - 40, i + 10))
        move(Point(WI - MA - MA - 40, i + 10))
    end
    line(Point(WI - MA - MA - 40, CIRCUITHEIGHT / 2))
    move(Point(WI - MA - MA - 40, CIRCUITHEIGHT / 2))
    line(Point(WI - MA - MA - 40 - CIRCUITWIDTH, CIRCUITHEIGHT / 2))
    move(Point(WI - MA - MA - 40 - CIRCUITWIDTH, CIRCUITHEIGHT / 2))
    line(Point(WI - MA - MA - 40 - CIRCUITWIDTH, 10))
    move(Point(WI - MA - MA - 40 - CIRCUITWIDTH, 10))
    line(Point(WI - MA - MA - 40 - CIRCUITWIDTH + 30, 10))
    line(Point(WI - MA - MA - 40 - CIRCUITWIDTH - 30, 10))
    strokepath()
    #
    fontsize(20)
    text(join([string(CCap), "F"]), WI - MA - MA - 40 - CIRCUITWIDTH - 110, 5)
    text(join([string(LInd), "H"]), WI - MA - MA - 40 - 70, 5)
end

function drawCharges(n, flag)
    spawnpx = WI - MA - MA - 40 - CIRCUITWIDTH - 30
    spawnpy = flag ? -10 : 10
    sethue("blue")
    for i in 0:n
        circle(Point(spawnpx + i * 5, spawnpy), 5, :fill)
    end
end

# function drawField(k, step, multiplier)
#     p1 = Point(WI - MA - MA - 40 + (I(step) * multiplier), -(I(step) * 2.5 * multiplier))
#     m = Point(WI - MA - MA - 40, 0)
#     p2 = Point(WI - MA - MA - 40 + (I(step) * multiplier), (I(step) * 2.5 * multiplier))

#     evilp1 = Point(WI - MA - MA - 40 - (I(step) * multiplier), -(I(step) * 2.5 * multiplier))
#     evilp2 = Point(WI - MA - MA - 40 - (I(step) * multiplier), (I(step) * 2.5 * multiplier))

#     ellipse(p1, p2, m, :stroke)
#     ngon(Point(WI - MA - MA - 40 + (2 * (I(step) * multiplier)), 0), 8, 3, sign(I(step))*0.5*pi, :fill)
#     ellipse(evilp1, evilp2, m, :stroke)
#     ngon(Point(WI - MA - MA - 40 - (2 * (I(step) * multiplier)), 0), 8, 3, sign(I(step))*0.5*pi, :fill)
# end

function drawFieldLine(step, k, n)
    x = WI - MA - MA - 40 + 8
    h = Point(x + sign(I(step))*-k*3, -30)
    b = Point(x + sign(I(step))*-k*3, 30)
    ha = Point(x - sign(I(step))*-k*3, -30)
    ba = Point(x - sign(I(step))*-k*3, 30)
    factor = exp((k-0.4)/3)
    # println(factor)
    move(b)
    line(h)
    strokepath()
    ngon(Point(x + sign(I(step))*-k*3 + factor * I(step) * 6000, 0), 8, 3, sign(I(step))*0.5*pi, :fill)
    move(h)
    curve(Point(x + sign(I(step))*-k*3 + factor * I(step) * 8000, -60 - abs(3*factor*exp(n + k) * I(step) * 50)), Point(x + sign(I(step))*-k*3 + factor * I(step) * 8000, 60 + abs(3*factor*exp(n + k) * I(step) * 50)), b)
    strokepath()
    move(ba)
    line(ha)
    strokepath()
    ngon(Point(x - sign(I(step))*-k*3 - factor * I(step) * 6000, 0), 8, 3, sign(I(step))*0.5*pi, :fill)
    move(ha)
    curve(Point(x - sign(I(step))*-k*3 - factor * I(step) * 8000, -60 - abs(3*factor*exp(n + k) * I(step) * 50)), Point(x - sign(I(step))*-k*3 - factor * I(step) * 8000, 60 + abs(3*factor*exp(n + k) * I(step) * 50)), ba)
    strokepath()
end

function drawField(step, n)
    for i in 1:n
        if abs(exp((i-1)/3) * (I(step) * 8000)) > 50*exp(i-2.2)
            drawFieldLine(step, -i + 1, n)
        end
    end
end

bbuffer = Vector{Point}()

sim = Movie(WI, HE, "LC")
t = 0
p = (x, y) -> Point(x * STX, -(y * STY))

function backdrop(scene, framenumber)
    background("white")
    origin(Point(MA, HE / 2))

    drawAxis()
    drawCircuit()
end

function frame(scene, framenumber)
    global t
    if t >= period
        empty!(bbuffer)
        t = 0
    end

    push!(bbuffer, p(t, dI(t)))

    sethue("blue")
    poly(bbuffer, :stroke)
    drawCharges(round(Int, (q(t) / Q) * 12, RoundDown), true)
    drawCharges(round(Int, (-q(t) / Q) * 12, RoundDown), false)

    UCond = q(t) / CCap
    sethue("black")
    text(join([string(round(Int, UCond)), "V"]), WI - MA - MA - CIRCUITWIDTH + 40, 5)
    text(join(["Stromstärke ", string(round(Int, I(t)*1000)), "mA"]), WI - MA - MA - CIRCUITWIDTH - 370, 300)
    text(" ~ Magnetfeldstärke B", WI - MA - MA - CIRCUITWIDTH - 200, 300)

    sethue("green")
    # drawField(5000, t, 2000)
    # drawField(5000, t, 1300)
    # drawField(5000, t, 500)
    drawField(t, 4)

    t = t + 0.007
end

  animate(sim, [
        Scene(sim, backdrop, 0:round(Int, period/0.007, RoundUp)),
        Scene(sim, frame, 0:round(Int, period/0.007, RoundUp),
            easingfunction=easeinoutcubic,
            optarg="made with Julia")
    ],
    creategif=true)

# @play WI HE begin
#     backdrop()
#     frame()
#     sleep(0.02)
# end
