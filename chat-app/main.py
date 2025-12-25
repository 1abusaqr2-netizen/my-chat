import flet as ft
import random

def main(page: ft.Page):
    page.title = "نظام المراسلة الموثق - م/ أصيل السبعي"
    page.rtl = True
    page.theme_mode = ft.ThemeMode.LIGHT
    page.vertical_alignment = ft.MainAxisAlignment.CENTER

    generated_otp = None

    txt_name = ft.TextField(label="الاسم المستعار")
    txt_phone = ft.TextField(label="رقم الهاتف")
    txt_otp = ft.TextField(label="أدخل كود التحقق", visible=False)

    chat_list = ft.ListView(expand=True, auto_scroll=True)
    msg_input = ft.TextField(hint_text="اكتب رسالة...", expand=True)

    def on_broadcast(data):
        is_me = data["phone"] == page.session.get("phone")
        chat_list.controls.append(
            ft.Text(f'{data["user"]}: {data["text"]}')
        )
        page.update()

    page.pubsub.subscribe(on_broadcast)

    def send_message(e):
        if msg_input.value:
            page.pubsub.send_all({
                "phone": page.session.get("phone"),
                "user": page.session.get("username"),
                "text": msg_input.value
            })
            msg_input.value = ""
            page.update()

    def verify_logic(e):
        nonlocal generated_otp
        if not txt_otp.visible:
            generated_otp = str(random.randint(1000, 9999))
            page.snack_bar = ft.SnackBar(ft.Text(f"كودك: {generated_otp}"), open=True)
            txt_otp.visible = True
            page.update()
        else:
            if txt_otp.value == generated_otp:
                page.session.set("phone", txt_phone.value)
                page.session.set("username", txt_name.value or "مستخدم")
                enter_chat()

    def enter_chat():
        page.clean()
        page.add(
            chat_list,
            ft.Row([msg_input, ft.IconButton(ft.icons.SEND, on_click=send_message)])
        )

    page.add(txt_name, txt_phone, txt_otp, ft.ElevatedButton("تسجيل الدخول", on_click=verify_logic))

ft.app(target=main, port=10000, view=ft.WEB_BROWSER)
