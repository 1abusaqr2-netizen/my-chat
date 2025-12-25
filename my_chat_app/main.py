import flet as ft

def main(page: ft.Page):
    page.title = "إنشاء وتصميم م/أصيل السبعي - دخول"
    page.theme_mode = ft.ThemeMode.LIGHT
    page.vertical_alignment = ft.MainAxisAlignment.CENTER

    def login_click(e):
        if not phone.value or not password.value:
            page.snack_bar = ft.SnackBar(ft.Text("يرجى إكمال البيانات!"))
            page.snack_bar.open = True
        else:
            # كلمة السر الافتراضية للتجربة هي 123456
            if password.value == "123456":
                page.clean()
                page.add(ft.Text(f"مرحباً بك: {phone.value}", size=25, color="green"))
                page.add(ft.Text("واجهة الدردشة قيد التحميل..."))
            else:
                page.snack_bar = ft.SnackBar(ft.Text("كلمة السر خاطئة!"))
                page.snack_bar.open = True
        page.update()

    phone = ft.TextField(label="رقم الهاتف", icon=ft.icons.PHONE)
    password = ft.TextField(label="كلمة السر", password=True, can_reveal_password=True)
    
    page.add(
        ft.Column([
            ft.Text("تسجيل الدخول", size=30, weight="bold"),
            phone,
            password,
            ft.ElevatedButton("دخول", on_click=login_click)
        ], horizontal_alignment=ft.CrossAxisAlignment.CENTER)
    )

ft.app(target=main, view=ft.AppView.WEB_BROWSER)
