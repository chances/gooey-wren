import "wren-assert/Assert" for Assert
import "./math" for Math

Assert.equal(Math.wrapRadians(Num.pi), Num.pi)
Assert.equal(Math.wrapRadians(Num.pi * 2), 0)
Assert.equal(Math.wrapRadians(Num.pi * 3), Num.pi)
Assert.equal(Math.wrapRadians(Num.pi * -2), 0)
Assert.equal(Math.wrapRadians(Num.pi * -3), Num.pi)
