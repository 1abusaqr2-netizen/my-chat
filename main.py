import flet as ft
import random
import os

def main(page: ft.Page):
    page.title = "إنشاء وتصميم م/أصيل السبعي (أبوصقر) "
    page.rtl = True
    page.theme_mode = ft.ThemeMode.LIGHT
    page.window_width = 450
    page.window_height = 750
    page.vertical_alignment = ft.MainAxisAlignment.CENTER

    generated_otp = None

    txt_name = ft.TextField(label="الاسم المستعار", prefix_icon=ft.icons.PERSON)
    txt_phone = ft.TextField(label="رقم الهاتف", prefix_icon=ft.icons.PHONE)
    txt_otp = ft.TextField(label="أدخل كود التحقق", prefix_icon=ft.icons.LOCK_CLOCK, visible=False)
    
    chat_list = ft.ListView(expand=True, spacing=10, auto_scroll=True)
    msg_input = ft.TextField(hint_text="اكتب رسالة...", expand=True)

    def on_broadcast(data):
        is_me = data["phone"] == page.session.get("phone")
        chat_list.controls.append(
            ft.Row(
                [
                    ft.Container(
                        content=ft.Column([
                            ft.Text(data["user"], size=10, color="blue", weight="bold"),
                            ft.Text(data["text"], size=16),
                        ], spacing=2),
                        bgcolor="#E1FFC7" if is_me else "#F0F0F0",
                        padding=10, border_radius=10,
                    )
                ],
                alignment=ft.MainAxisAlignment.END if is_me else ft.MainAxisAlignment.START
            )
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
            if len(txt_phone.value) < 5:
                txt_phone.error_text = "الرقم قصير جداً"
                page.update()
                return
            
            generated_otp = str(random.randint(1000, 9999))
            page.snack_bar = ft.SnackBar(ft.Text(f"كود التحقق الخاص بك هو: {generated_otp}"), open=True)
            
            txt_phone.disabled = True
            txt_name.disabled = True
            txt_otp.visible = True
            btn_login.text = "تأكيد الكود"
            page.update()
        else:
            if txt_otp.value == generated_otp:
                page.session.set("phone", txt_phone.value)
                page.session.set("username", txt_name.value or "مستخدم")
                enter_chat_room()
            else:
                txt_otp.error_text = "الكود غير صحيح!"
                page.update()

    def enter_chat_room():
        page.clean()
        page.appbar = ft.AppBar(title=ft.Text(f"المستخدم: {page.session.get('username')}"), bgcolor="gold")
        page.add(ft.Column([ft.Container(content=chat_list, expand=True), ft.Row([msg_input, ft.IconButton(ft.icons.SEND, on_click=send_message)])], expand=True))

    btn_login = ft.ElevatedButton("إرسال كود التحقق", on_click=verify_logic, width=250, bgcolor="gold", color="black")
    
    page.add(ft.Column([ft.Icon(ft.icons.SECURITY, size=50, color="gold"), txt_name, txt_phone, txt_otp, btn_login], horizontal_alignment=ft.CrossAxisAlignment.CENTER))

# تشغيل التطبيق كويب وتحديد المنفذ تلقائياً للسيرفر
if __name__ == "__main__":
    port = int(os.getenv("PORT", 8502))
    ft.app(target=main, view=ft.AppView.WEB_BROWSER, port=port)
