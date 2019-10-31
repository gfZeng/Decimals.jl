@testset "Arithmetic" begin
    Decimals.setprecision!(precision=4)
    @test d"1" / 3 == 0.3333

    Decimals.setprecision!(precision=5)
    @test d"1" / 3 == 0.33333 == Decimals.One / Decimal(3)

    Decimals.setprecision!(precision=3, rounding=RoundUp)
    @test one(Decimal) * d"4.2" == 4.2 == d"42E-1"
    @test 4.2 * d"4.2" == 4.2 * 4.2 == d"42E-1" * d"4.2"
    @test d"1" / 3 == 0.334 == Decimals.One / Decimal(3)
    @test d"-1" / 3 == -0.334 == -Decimals.One / Decimal(3)
    @test d"1" + d"2" == d"3" == d"40E-1" - d"100E-2"
end
