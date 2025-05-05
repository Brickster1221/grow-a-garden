#Requires AutoHotkey v2.0

check_menu(close:=false) {
    local value := false
    local foundx := 0
    local foundy := 0
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/x.png")
        if outx {
            foundx := outx
            foundy := outy
            value := true
        }
    }
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/x-sel.png")
        if outx {
            foundx := outx
            foundy := outy            
            value := true
        }
    }
    if close {
        MouseMove(foundx, foundy, 0)
        MouseClick()
    }
    return value
}

get_buy() {
    local value := false
    local foundx := 0
    local foundy := 0
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/buy.png")
        if outx {
            foundx := outx
            foundy := outy
            value := true
        }
    }
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/buy-sel.png")
        if outx {
            foundx := outx
            foundy := outy            
            value := true
        }
    }
    
    if value {
        MouseMove(foundx, foundy, 10)
    }
    return value
}

buy_item() {
    try {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/money.png")
        MouseClick('L', outx, outy)
        Sleep(1000)
        if get_buy() {
            loop 20 {
                Sleep(200)
                MouseClick()
            }
        }   
        try {
            ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/scroll.png")
            MouseMove(outx, outy)
        } catch as e {
            return
        }
        return
    } catch as e {
        return
    }
}

check_stock() {
    global funcran
    if check_menu() {
        try {
            ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/scroll.png")
            MouseMove(outx, outy)
        } catch as e {
            return
        }
        Sleep(100)
        Send "{WheelDown 100}"
        loop 50 {
            Sleep(200)
            buy_item()
            Send "{WheelUp}"
            Send "o" ; just incase it zooms in all the way
        }
        funcran := false
    } else {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/seedtp.png")
        if outx {
            MouseClick('L', outx, outy)
        } else If (outx) {
            ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/seedtp-sel.png")
            MouseClick('L', outx, outy)
        }
        loop 100 {
            if check_menu() {
                check_stock
                return
            }
            Send "{Left down}"
            Send "e"
            Sleep(100)
            Send "{Left up}"
        }
        funcran := false
    }
}

funcran := true
runfunc() {
    global funcran
    if (Mod(A_Min, 5) == 0 and not funcran) {
        funcran := true
        check_stock()
    }
}

Running := false

^o:: {
    global Running
    if Running {
        Running := false
        SetTimer(runfunc, 0)
    } else {
        Running := true
        funcran := true
        check_stock()
        SetTimer(runfunc, 10000)
    }
}

^t:: {
    ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/rain-weather.png")
    if outx {
        MouseMove(outx, outy)
    } else {
        MsgBox "False"
    }
}

^q:: ExitApp