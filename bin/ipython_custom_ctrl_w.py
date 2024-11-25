from IPython import get_ipython
import string

def custom_delete_word(event):
    buffer = event.current_buffer
    text = buffer.text
    cursor_pos = buffer.cursor_position

    # word_chars = string.ascii_letters + string.digits + '_.'
    word_chars = string.ascii_letters + string.digits + '_'

    delete_start = cursor_pos

    # 向左遍历，跳过任何分隔符
    while delete_start > 0 and text[delete_start - 1] not in word_chars:
        delete_start -= 1

    # 向左遍历，找到第一个分隔符
    while delete_start > 0 and text[delete_start - 1] in word_chars:
        delete_start -= 1

    delete_count = cursor_pos - delete_start
    buffer.delete_before_cursor(count=delete_count)

# 获取 IPython 实例
ip = get_ipython()

if ip and hasattr(ip, 'pt_app'):
    # 获取当前的 key bindings
    kb = ip.pt_app.key_bindings

    # 绑定 Ctrl-W 到自定义的删除函数
    @kb.add('c-w')
    def _(event):
        custom_delete_word(event)
