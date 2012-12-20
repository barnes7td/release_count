class Type_Categories

  attr_reader  :codes, :types, :bom, :details, :ship_loose_ea, :sheet_total, :adjust_name, :tmr

  def initialize
    @codes = {
      "B2" => :bend2,
      "B4" => :bend4,
      "B6" => :bend6,
      "BM" => :bend_mixed,
      "BC" => :bend_custom,
      "RC" => :rail,
      "R2" => :rail2,
      "R3" => :rail3,
      "R4" => :rail4,
      "RR" => :rail_rolled,
      "RH" => :rail_hang_off,
      "RA" => :rail_panel,
      "DT" => :detail,
      "PS" => :post,
      "PK" => :picket,
      "SH" => :sheet,
      "PA" => :part,
      "PL" => :panel,
      "IN" => :insert,
      "KP" => :kickplate,
      "CH" => :chain,
      "AS" => :assembly,
      "GL" => :glass_panel,
      "KD" => :kp_detail,
      "GP" => :group,
      "ST" => :stock,
      "LP" => :light_pole,
      "MA" => :machining,
      "GA" => :gate,
      "SE" => :section,
      "BV" => :bevel
    }

    @types = [:bend2, :bend4, :bend6, :bend_mixed, :bend_custom, :rail, :rail2, :rail3, :rail4, :rail_rolled, :rail_hang_off, :rail_panel, :detail, 
              :post, :picket, :sheet, :part, :panel, :insert, :kickplate, :chain, :assembly, :glass_panel, :kp_detail, :group, 
              :stock, :light_pole, :machining, :gate, :section, :bevel]
    @bom = [:post, :insert, :picket, :rail, :rail2, :rail3, :rail4, :rail_rolled, :rail_hang_off, :bend2, :bend4, :bend6, :bend_mixed]
    @details = [:detail, :kp_detail]
    @ship_loose_ea = [:rail_panel, :rail, :post, :kickplate, :glass_panel, :light_pole, :panel, :gate]
    @sheet_total = [:post, :insert, :picket, :detail, :kp_detail, :kickplate, :bend_custom, :panel]
    @adjust_name = [:rail, :rail2, :rail_rolled, :rail_hang_off, :bend2, :bend4, :bend6, :bend_mixed]
    @tmr = [:stock, :part, :chain]
  end

end