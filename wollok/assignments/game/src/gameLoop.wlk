import _scheduler.*


object gameLoop {
    const fns = new Dictionary()
    
    method start() {
        scheduler.every(60, "game_loop", {fns.values().forEach({fn => fn.apply()})})
    }

    method add(id, fn) {
        fns.put(id, fn)
    }

    method remove(id) {
        fns.remove(id)
    }
}
