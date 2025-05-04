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
        MouseMove(foundx, foundy, 0)
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
                Sleep(100)
                MouseClick()
                Sleep(100)
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
    if check_menu() {
        try {
            ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/scroll.png")
            MouseMove(outx, outy)
        } catch as e {
            return
        }
        Send "{WheelDown 100}"
        loop 50 {
            buy_item()
            Sleep(200)
            Send "{WheelUp}"
        }
    } else {
        ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/seedtp.png")
        if outx {
            MouseClick('L', outx, outy)
        } else {
            ImageSearch(&outx, &outy, 0, 0, A_ScreenWidth, A_ScreenHeight, "Images/seedtp-sel.png")
            MouseClick('L', outx, outy)
        }
        loop 10 {
            if check_menu() {
                check_stock
                return
            }
            Send "{Left down}"
            Send "e"
            Sleep(100)
            Send "{Left up}"
        }
    }
}

Running := false

^o:: {
    global Running
    if Running {
        Running := false
        SetTimer(check_stock, 0)
    } else {
        Running := true
        check_stock()
        SetTimer(check_stock, 300000)
    }
}

^q:: ExitApp