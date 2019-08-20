class Isometric
    attr_accessor :grid, :inputs, :state, :outputs

    def tick
        defaults
        render
        calc
        process_inputs
    end

    def defaults
        state.quantity  ||= 1     #Size of grid
        state.tileSize  ||= [262 / 2, 194 / 2]
        state.tileGrid  ||= []
        state.tileCords ||= []
        state.initCords ||= [640 - (state.quantity / 2 * state.tileSize[0]), 330]    #Location of tile (0, 0)
        state.sideSize  ||= [state.tileSize[0] / 2, 242 / 2]

        if state.tileGrid == []
            tempX = 0
            tempY = 0
            tempLeft = false
            tempRight = false
            count = 0
            (state.quantity * state.quantity).times do
                if tempY == 0
                    tempLeft = true
                end
                if tempX == (state.quantity - 1)
                    tempRight = true
                end
                state.tileGrid.push([tempX, tempY, true, tempLeft, tempRight, count])
                #orderX, orderY, exists?, leftSide, rightSide, order
                tempX += 1
                if tempX == state.quantity
                    tempX = 0
                    tempY += 1
                end
                tempLeft = false
                tempRight = false
                count += 1
            end
        end

        if state.tileCords == []
            state.tileCords = state.tileGrid.map do
                |val|
                x = (state.initCords[0]) + ((val[0] + val[1]) * state.tileSize[0] / 2)
                y = (state.initCords[1]) + (-1 * val[0] * state.tileSize[1] / 2) + (val[1] * state.tileSize[1] / 2)
                [x, y, val[2], val[3], val[4], val[5]]
            end
        end

    end

    def render
        outputs.solids << [0, 0, 1280, 720, 0, 0, 0]
        outputs.sprites << state.tileCords.map do
            |val|
            if val[2] == true
                if val[3] == true
                    [val[0], val[1] + (state.tileSize[1] / 2) - state.sideSize[1], state.sideSize[0],
                    state.sideSize[1], 'sprites/leftSide.png']
                end
            end
        end

        outputs.sprites << state.tileCords.map do
            |val|
            if val[2] == true
                if val[4] == true
                    [val[0] + state.tileSize[0] / 2, val[1] + (state.tileSize[1] / 2) - state.sideSize[1], state.sideSize[0],
                    state.sideSize[1], 'sprites/rightSide.png']
                end
            end
        end

        outputs.sprites << state.tileCords.map do
            |val|
            if val[2] == true
                [val[0], val[1], state.tileSize[0], state.tileSize[1], 'sprites/tile.png']
            end
        end

    end

    def calc
        
    end

    def process_inputs
        if inputs.keyboard.key_up.r
            $dragon.reset
        end

        if inputs.mouse.down
            x = inputs.mouse.down.point.x
            y = inputs.mouse.down.point.y
            m = (state.tileSize[1] / state.tileSize[0])
            state.tileCords.map do
                |val|
                next unless val[0] < x && x < val[0] + state.tileSize[0]
                next unless val[1] < y && y < val[1] + state.tileSize[1]
                tempBool = false
                if x == val[0] + (state.tileSize[0] / 2)
                    tempBool = true
                elsif x < state.tileSize[0] / 2 + val[0]
                    tempY1 =      (m * (x - val[0])) + val[1] + (state.tileSize[1] / 2)
                    tempY2 = (-1 * m * (x - val[0])) + val[1] + (state.tileSize[1] / 2)
                    tempBool = true if y < tempY1 && y > tempY2
                elsif x > state.tileSize[0] / 2 + val[0]
                    puts 'right side detected'
                    tempY1 =      (m * (x - val[0] + (state.tileSize[0] / 2))) + val[1]
                    tempY2 = (-1 * m * (x - val[0] + (state.tileSize[0] / 2))) + val[1] + state.tileSize[1]
                    puts y.to_s + " " + tempY1.to_s + " " + tempY2.to_s
                    tempBool = true if y > tempY1 && y < tempY2
                    puts 'changed bool' if y > tempY1 && y < tempY2
                end

                if tempBool == true
                    val[2] = false
                    state.tileGrid[val[5]][2]  = false
                    state.tileCords[val[5]][2] = false
                    unless state.tileGrid[val[5]][0] == 0
                      state.tileGrid[val[5] - 1][4] = true
                      state.tileCords[val[5] - 1][4] = true
                    end
                    unless state.tileGrid[val[5]][1] == state.quantity - 1
                      state.tileGrid[val[5] + state.quantity][3] = true
                      state.tileCords[val[5] + state.quantity][3] = true
                    end
                end
            end
        end
    end

end

$isometric = Isometric.new

def tick args
    $isometric.grid    = args.grid
    $isometric.inputs  = args.inputs
    $isometric.state   = args.state
    $isometric.outputs = args.outputs
    $isometric.tick
end
