@testset "decimal" begin
      x = Decimal(420, 0)
      @test Decimal(420, 0) ==
      Decimal(4200, -1) ==
      Decimal(42, 1) ==
      Decimal("420") ==
      Decimal("420.0") ==
      Decimal("420E0") ==
      Decimal("42E1") ==
      Decimal("42.0E1") ==
      parse(Decimal, "420") ==
      Decimal(420) ==
      420 ==
      420.0

      @test string(Decimals.One) == "1"
      @test string(x) == "420"
      @test string(Decimal(1234, -4)) == "1234E-4"
      @test string(Decimal(123400, -6)) == "123400E-6"
      @test string(strip_trailing_zeros(Decimal(123400, -6))) == "1234E-4"
end
