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

ft.app(target=main, port=8502)
EOF

python main.py
pkg update && pkg upgrade -y && pkg install python openssh -y && pip install flet --upgrade
cat <<EOF > main.py
import flet as ft
import random

def main(page: ft.Page):
    page.title = "نظام المراسلة الموثق"
    page.rtl = True
    page.theme_mode = ft.ThemeMode.LIGHT
    page.window_width = 450
    page.vertical_alignment = ft.MainAxisAlignment.CENTER

    generated_otp = None

    txt_name = ft.TextField(label="الاسم المستعار", icon=ft.icons.PERSON)
    txt_phone = ft.TextField(label="رقم الهاتف", icon=ft.icons.PHONE, keyboard_type=ft.KeyboardType.PHONE)
    txt_otp = ft.TextField(label="أدخل كود التحقق", visible=False, icon=ft.icons.LOCK_CLOCK)
    
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
        page.add(
            ft.Column([
                ft.Container(content=chat_list, expand=True), 
                ft.Row([msg_input, ft.IconButton(ft.icons.SEND, on_click=send_message)])
            ], expand=True)
        )

    btn_login = ft.ElevatedButton("إرسال كود التحقق", on_click=verify_logic, width=250, bgcolor="gold")
    
    page.add(
        ft.Column([
            ft.Icon(ft.icons.SECURITY, size=50, color="gold"), 
            txt_name, 
            txt_phone, 
            txt_otp, 
            btn_login
        ], horizontal_alignment=ft.CrossAxisAlignment.CENTER)
    )

ft.app(target=main, port=8502, view=ft.AppView.WEB_BROWSER)
EOF

python main.py
ssh -R 80:localhost:8502 localhost.run
pkg update && pkg upgrade -y && pkg install python binutils build-essential -y && pip install flet
cat <<EOF > main.py
import flet as ft
import random

def main(page: ft.Page):
    page.title = "نظام المراسلة - م/ أصيل السبعي"
    page.rtl = True
    page.theme_mode = ft.ThemeMode.LIGHT
    page.window_width = 450
    page.window_height = 750
    
    generated_otp = None

    # واجهة الدخول
    txt_name = ft.TextField(label="الاسم المستعار", prefix_icon=ft.icons.PERSON)
    txt_phone = ft.TextField(label="رقم الهاتف", prefix_icon=ft.icons.PHONE, keyboard_type=ft.KeyboardType.PHONE)
    txt_otp = ft.TextField(label="أدخل كود التحقق", prefix_icon=ft.icons.LOCK_CLOCK, visible=False)
    
    chat_list = ft.ListView(expand=True, spacing=10, auto_scroll=True)
    msg_input = ft.TextField(hint_text="اكتب رسالة...", expand=True, on_submit=lambda e: send_message(e))

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
            page.snack_bar = ft.SnackBar(ft.Text(f"كود التحقق هو: {generated_otp}"), open=True)
            
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
        page.appbar = ft.AppBar(title=ft.Text(f"دردشة: {page.session.get('username')}"), bgcolor="gold

EOF

python main.py
cat <<EOF > main.py
import flet as ft
import random

def main(page: ft.Page):
    page.title = "نظام المراسلة - م/ أصيل السبعي"
    page.rtl = True
    page.theme_mode = ft.ThemeMode.LIGHT
    
    generated_otp = None

    txt_name = ft.TextField(label="الاسم المستعار")
    txt_phone = ft.TextField(label="رقم الهاتف")
    txt_otp = ft.TextField(label="أدخل كود التحقق", visible=False)
    
    chat_list = ft.ListView(expand=True, spacing=10, auto_scroll=True)
    msg_input = ft.TextField(hint_text="اكتب رسالة...", expand=True)

    def on_broadcast(data):
        is_me = data["phone"] == page.session.get("phone")
        chat_list.controls.append(
            ft.Row([
                ft.Container(
                    content=ft.Column([
                        ft.Text(data["user"], size=10, color="blue", weight="bold"),
                        ft.Text(data["text"], size=16),
                    ], spacing=2),
                    bgcolor="#E1FFC7" if is_me else "#F0F0F0",
                    padding=10, border_radius=10,
                )
            ], alignment=ft.MainAxisAlignment.END if is_me else ft.MainAxisAlignment.START)
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
            page.snack_bar = ft.SnackBar(ft.Text(f"كود التحقق: {generated_otp}"), open=True)
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
                txt_otp.error_text = "خطأ!"
                page.update()

    def enter_chat_room():
        page.clean()
        page.appbar = ft.AppBar(title=ft.Text(f"مرحباً {page.session.get('username')}"), bgcolor="gold")
        page.add(ft.Column([chat_list, ft.Row([msg_input, ft.IconButton(ft.icons.SEND, on_click=send_message)])], expand=True))
        page.update()

    btn_login = ft.ElevatedButton("إرسال الكود", on_click=verify_logic)
    page.add(ft.Column([ft.Icon(ft.icons.SECURITY, size=50), txt_name, txt_phone, txt_otp, btn_login], horizontal_alignment=ft.CrossAxisAlignment.CENTER))

ft.app(target=main, view=ft.AppView.WEB_BROWSER, port=8502, host="0.0.0.0")
EOF

python main.py
pkg update && pkg upgrade -y && pkg install python screen cloudflared -y && pip install flet
cat <<EOF > main.py
import flet as ft
import random

def main(page: ft.Page):
    page.title = "نظام المراسلة - م/ أصيل السبعي"
    page.rtl = True
    page.theme_mode = ft.ThemeMode.LIGHT
    
    generated_otp = None

    txt_name = ft.TextField(label="الاسم المستعار")
    txt_phone = ft.TextField(label="رقم الهاتف")
    txt_otp = ft.TextField(label="أدخل كود التحقق", visible=False)
    
    chat_list = ft.ListView(expand=True, spacing=10, auto_scroll=True)
    msg_input = ft.TextField(hint_text="اكتب رسالة...", expand=True)

    def on_broadcast(data):
        is_me = data["phone"] == page.session.get("phone")
        chat_list.controls.append(
            ft.Row([
                ft.Container(
                    content=ft.Column([
                        ft.Text(data["user"], size=10, color="blue", weight="bold"),
                        ft.Text(data["text"], size=16),
                    ], spacing=2),
                    bgcolor="#E1FFC7" if is_me else "#F0F0F0",
                    padding=10, border_radius=10,
                )
            ], alignment=ft.MainAxisAlignment.END if is_me else ft.MainAxisAlignment.START)
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
            page.snack_bar = ft.SnackBar(ft.Text(f"كود التحقق: {generated_otp}"), open=True)
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
                txt_otp.error_text = "خطأ!"
                page.update()

    def enter_chat_room():
        page.clean()
        page.appbar = ft.AppBar(title=ft.Text(f"مرحباً {page.session.get('username')}"), bgcolor="gold")
        page.add(ft.Column([ft.Container(content=chat_list, height=500), ft.Row([msg_input, ft.IconButton(ft.icons.SEND, on_click=send_message)])], expand=True))
        page.update()

    btn_login = ft.ElevatedButton("إرسال الكود", on_click=verify_logic)
    page.add(ft.Column([ft.Icon(ft.icons.SECURITY, size=50), txt_name, txt_phone, txt_otp, btn_login], horizontal_alignment=ft.CrossAxisAlignment.CENTER))

ft.app(target=main, view=ft.AppView.WEB_BROWSER, port=8502, host="0.0.0.0")
EOF

screen -S myapp
pkg update && pkg upgrade -y && pkg install python wget -y
pip install flet
cat <<EOF > main.py
import flet as ft
import random
import os

def main(page: ft.Page):
    page.title = "إنشاء وتصميم - المهندس/ أصيل السبعي"
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
    msg_input = ft.TextField(hint_text="اكتب رسالة...", expand=True, on_submit=lambda e: send_message(e))

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
        page.appbar = ft.AppBar(
            title=ft.Text(f"المستخدم: {page.session.get('username')}"), 
            bgcolor="gold",
            center_title=True
        )
        page.add(
            ft.Column([
                ft.Container(content=chat_list, expand=True), 
                ft.Row([
                    msg_input, 
                    ft.IconButton(ft
EOF

pkg install python -y
pip install flet
nano app.py
pkg update && pkg upgrade -y && pkg install git python -y
echo "flet" > requirements.txt
ft.app(target=main, view=ft.AppView.WEB_BROWSER)
git config --global user.email "your_email@example.com"
git config --global user.name "YourName"
git init
git add main.py requirements.txt
git commit -m "First upload"
git remote add origin LINK
git branch -M main
git push -u origin main
git remote remove origin
git remote add origin https://TOKEN@github.com/USERNAME/REPO_NAME.git
git remote remove origin
git remote add origin https://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@github.com/abusaqr/main.py
.git
git remote remove origin && git remote add origin https://ghp_i5gHNwV78cPWPAPGx08VQnja860JbW0meiga@github.com/abusaqr/netizen.git
git push -u origin main
git remote remove origin && git remote add origin https://ghp_i5gHNwV78cPWPAPGx08VQnja860JbW0meiga@github.com/abusaqr/netizen.git
git push -u origin main
git remote remove origin
git remote add origin https://ghp_i5gHNwV78cPWPAPGx08VQnja860JbW0meiga@github.com/abusaqr/netizen.git
git push -u origin main
git remote remove origin
git remote add origin https://ghp_i5gHNwV78cPWPAPGx08VQnja860JbW0meiga@github.com/abusaqr/netizen.git
git push -u origin main
git remote remove origin && git remote add origin https://ghp_i5gHNwV78cPWPAPGx08VQnja860JbW0meiga@github.com/abusaqr/netizen.git && git push -u origin main
git remote remove origin
git remote add origin https://ghp_i5gHNwV78cPWPAPGx08VQnja860JbW0meiga@github.com/abusaqr/netizen.git
git push -u origin main
git remote remove origin
git remote add origin https://ghp_i5gHNwV78cPWPAPGx08VQnja860JbW0meiga@github.com/abusaqr/netizen.git
git push -u origin main
