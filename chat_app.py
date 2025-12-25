import flet as ft

def main(page: ft.Page):
    # إعدادات الصفحة الأساسية
    page.title = "تطبيق أبوصقر السُبعي للدردشة"
    page.rtl = True # دعم العربية
    page.theme_mode = ft.ThemeMode.LIGHT
    page.window_width = 400
    page.bgcolor = "#ece5dd" # لون خلفية واتساب الشهير

    # متغيرات لتخزين البيانات
    user_name = "أصيل فضل السبعي"

    # --- وظائف الانتقال ---
    def go_to_chat(e):
        if code_field.value == "123456": # الكود الافتراضي للتجربة
            show_main_app()
        else:
            page.snack_bar = ft.SnackBar(ft.Text("عذراً، رمز الكود غير صحيح!"))
            page.snack_bar.open = True
            page.update()

    def show_verify_field(e):
        if phone_field.value:
            phone_field.disabled = True
            send_btn.visible = False
            verify_container.visible = True
            page.update()

    # --- واجهة تسجيل الدخول ---
    phone_field = ft.TextField(label="رقم الهاتف", prefix_text="+", border_color="green")
    code_field = ft.TextField(label="أدخل رمز الكود (123456)", password=True, can_reveal_password=True)
    send_btn = ft.ElevatedButton("إرسال رمز الكود", on_click=show_verify_field, bgcolor="green", color="white")
    
    verify_container = ft.Column([
        code_field,
        ft.ElevatedButton("تأكيد ودخول", on_click=go_to_chat, bgcolor="green", color="white")
    ], visible=False)

    login_screen = ft.Container(
        content=ft.Column([
            ft.Image(src="https://upload.wikimedia.org/wikipedia/commons/6/6b/WhatsApp.svg", width=100),
            ft.Text("هذا التطبيق من إنشاء المهندس/أصيل فضل السبعي(أبوصقر) ", size=20, weight="bold"),
            phone_field,
            send_btn,
            verify_container
        ], horizontal_alignment=ft.CrossAxisAlignment.CENTER),
        padding=20
    )

    # --- واجهة الدردشة والملاحظات ---
    def show_main_app():
        page.clean()
        

        # قائمة الرسائل
        messages = ft.Column(scroll=ft.ScrollMode.ALWAYS, expand=True)
        chat_input = ft.TextField(hint_text="اكتب رسالتك هنا  ...", expand=True, border_radius=20)
        
        def send_message(e):
            if chat_input.value:
                messages.controls.append(
                    ft.Container(
                        content=ft.Text(chat_input.value, color="black"),
                        alignment=ft.alignment.center_right,
                        bgcolor="#dcf8c6",
                        padding=10,
                        border_radius=10,
                        margin=5
                    )
                )
                chat_input.value = ""
                page.update()

        # تبويب الملاحظات
        notes_input = ft.TextField(label="أضف ملاحظة جديدة", multiline=True)
        notes_list = ft.Column()

        def add_note(e):
            if notes_input.value:
                notes_list.controls.append(ft.ListTile(title=ft.Text(notes_input.value), leading=ft.Icon(ft.icons.NOTE)))
                notes_input.value = ""
                page.update()

        # التنقل السفلي
        tabs = ft.Tabs(
            selected_index=0,
            tabs=[
                ft.Tab(text="الدردشات", content=ft.Column([
                    messages, 
                    ft.Row([chat_input, ft.IconButton(ft.icons.SEND, on_click=send_message, icon_color="green")])
                ], expand=True)),
                ft.Tab(text="الملاحظات", content=ft.Column([
                    notes_input, 
                    ft.ElevatedButton("حفظ الملاحظة", on_click=add_note),
                    notes_list
                ]))
            ], expand=True
        )

        page.add(
            ft.AppBar(title=ft.Text(f"تطبيق {user_name}"), bgcolor="#075e54", color="white"),
            tabs
        )

    # تشغيل شاشة الدخول أولاً
    page.add(login_screen)

ft.app(target=main)
