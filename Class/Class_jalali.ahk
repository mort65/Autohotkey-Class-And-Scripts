;Author: https://github.com/mort65/
 Class jalali {
    Static InitClass := jalali.ClassInit()
    ; ===================================================================================================================
    ; Constructor / Destructor
    ; ===================================================================================================================
    __New() { ; You must not instantiate this class!
      If (This.InitClass == "!DONE!") { ; external call after class initialization
         This["!Access_Denied!"] := True
         Return False
      }
    }
    ; ----------------------------------------------------------------------------------------------------------------
    __Delete() {
      If This["!Access_Denied!"]
         Return
      This.Free()
    }
    ; ===================================================================================================================
    ; ClassInit       Internal creation of a new instance to ensure that __Delete() will be called.
    ; ===================================================================================================================
    ClassInit() {
      jalali := New jalali
      Return "!DONE!"
    }
    
    gregorian_to_jalali(gy, gm, gd) {
        ;converts gregorian date to jalali
        g_d_m := [ 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334 ]
        gy2 := (gm > 2) ? (gy + 1) : gy
        days := 355666 + (365 * gy) + (((gy2 + 3) // 4)) - (((gy2 + 99) // 100)) + (((gy2 + 399) // 400)) + gd + g_d_m[gm]
        jy := -1595 + (33 * ((days // 12053)))
        days := Mod(days,12053)
        jy += 4 * ((days // 1461))
        days := Mod(days,1461)
        if (days > 365)
        {
            jy += ((days - 1) // 365)
            days := Mod((days - 1),365)
        }
        jm := (days < 186) ? 1 + (days // 31) : 7 + ((days - 186) // 30)
        jd := 1 + ((days < 186) ? Mod(days,31) : (Mod((days - 186),30)))
        jalali := [ jy, jm, jd ]
        return jalali
    }


    jalali_to_gregorian(jy, jm, jd) {
        ;;converts jalali date to gregorian
        jy += 1595
        days := -355668 + (365 * jy) + (( (jy // 33)) * 8) + ((Mod(jy,33) + 3) // 4) + jd + ((jm < 7) ? (jm - 1) * 31 : ((jm - 7) * 30) + 186)
        gy := 400 * ((days // 146097))
        days := Mod(days,146097)
        if (days > 36524) {
            gy += 100 * ((--days // 36524))
            days := Mod(days,36524)
            if (days >= 365) 
                days++
        }
        gy += 4 * ((days // 1461))
        days := Mod(days,1461)
        if (days > 365) {
            gy +=  ((days - 1) // 365)
            days := Mod((days - 1),365)
        }
        gd := days + 1
        sal_a := [ 0, 31, ((Mod(gy,4) == 0 && Mod(gy,100) != 0) || (Mod(gy,400) == 0)) ? 29 : 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ]
        gm := 1
        while(gm < 14 && gd > sal_a[gm]) {
            gd -= sal_a[gm]
            gm+=1
        }
        gregorian := [ gy, gm - 1, gd ]
        return gregorian
    } 

}

