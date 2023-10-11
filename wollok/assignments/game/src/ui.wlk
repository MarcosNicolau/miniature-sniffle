import constants.COLORS.*

/**
* This class expects an object with a health and position values defined
*/
class HealthBar {
    const parent
    // This defines how up should the bar be. 
    // This has to be provided by each object since  there is no way to know the height of it and as so define how up to it should be 
    const upFromPos
    method position() = parent.position().up(upFromPos)
    method text() = "Health  left: " + parent.health() 
    method message() = "Health  left: " + parent.health() 
    method color() {
        if( parent.health() > 75) return green
        if(parent.health() < 25)return red
        return yellow
    }
}