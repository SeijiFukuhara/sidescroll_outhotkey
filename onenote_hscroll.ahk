#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================
; OneNote: Ctrl + Shift + マウスホイール で横スクロール
;   ホイール上 → 左へ / ホイール下 → 右へ
; ============================================================

; 1回のホイール操作で何ノッチ分スクロールするか(速さ調整)
global SCROLL_STEPS := 3

; 方式の切り替え
;   1 = WheelLeft/WheelRight を送る(通常はこれでOK)
;   2 = WM_MOUSEHWHEEL メッセージを直接送る(1で効かない場合に試す)
global METHOD := 1

; OneNote(デスクトップ版 / Microsoft 365版)のウィンドウでだけ有効
#HotIf WinActive("ahk_exe ONENOTE.EXE")

^+WheelUp:: HScroll(-1)   ; 左へ
^+WheelDown:: HScroll(1)  ; 右へ

#HotIf

HScroll(direction) {
    if (METHOD = 1) {
        ; ホットキー実行中は押しっぱなしの Ctrl/Shift が自動で解除されて送られる
        key := (direction < 0) ? "{WheelLeft " SCROLL_STEPS "}" : "{WheelRight " SCROLL_STEPS "}"
        Send key
    } else {
        CoordMode "Mouse", "Screen"
        MouseGetPos &x, &y, , &ctrlHwnd, 2
        if !ctrlHwnd
            return
        ; WM_MOUSEHWHEEL (0x020E): 正の値 = 右, 負の値 = 左
        delta := 120 * SCROLL_STEPS * direction
        wParam := (delta & 0xFFFF) << 16
        lParam := ((y & 0xFFFF) << 16) | (x & 0xFFFF)
        PostMessage 0x020E, wParam, lParam, , "ahk_id " ctrlHwnd
    }
}
