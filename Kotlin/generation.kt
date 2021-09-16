import kotlin.math.PI
import kotlin.math.asin
import kotlin.math.sqrt
import kotlin.random.Random
import kotlin.system.measureTimeMillis

fun main() {
    val n = 2_000_000
    val rands = DoubleArray(n)
    val gen = Random(321)

    // 1st variant

    val duration1 = measureTimeMillis {
        var i = 0
        while (i < n) {
            val r1 = gen.nextDouble()
            val r2 = gen.nextDouble()
            if (r2 < asin(sqrt(r1)) / (PI / 2)) {
                rands.set(i, r1)
                i++
            }
        }
    }
    var sum = 0.0
    for (r in rands) {
        sum += r
    }
    println("1st variant:")
    println("average = ${sum / n}")
    println("generation takes ${1e-3 * duration1} s")

    // 2nd variant

    // Park-Miller RNG
    val a: Long = 48_271
    val m: Long = 2_147_483_647
    fun pm(state: Long): Long {
        return state * a % m
    }
    fun toD(state: Long): Double {
        return state.toDouble() / m.toDouble()
    }

    val duration2 = measureTimeMillis {
        var i = 0
        var s: Long = 42
        while (i < n) {
            s = pm(s)
            val r1 = toD(s)
            s = pm(s)
            val r2 = toD(s)
            if (r2 < asin(sqrt(r1)) / (PI / 2)) {
                rands.set(i, r1)
                i++
            }
        }
    }
    sum = 0.0
    for (r in rands) {
        sum += r
    }
    println("2nd variant:")
    println("average = ${sum / n}")
    println("generation takes ${1e-3 * duration2} s")

    // 3rd variant

    val duration3 = measureTimeMillis {
        var i = 0
        var s: Long = 142
        sum = 0.0
        while (i < n) {
            s = pm(s)
            val r1 = toD(s)
            s = pm(s)
            val r2 = toD(s)
            if (r2 < asin(sqrt(r1)) / (PI / 2)) {
                sum += r1
                i++
            }
        }
    }
    println("3nd variant:")
    println("average = ${sum / n}")
    println("generation takes ${1e-3 * duration3} s")

}

