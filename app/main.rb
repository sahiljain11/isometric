class isometric
    def tick
        defaults
        render
        calc
        process_inputs
    end

    def defaults
        
    end

    def render

    end

    def calc

    end

    def process_inputs

    end

end

$isometric = isometric.new

def tick args
    $isometric.grid    = args.grid
    $isometric.inputs  = args.inputs
    $isometric.state   = args.state
    $isometric.outputs = args.outputs
    $isometric.tick
end
