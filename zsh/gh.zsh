# 用法： ghsi <search-term>
# 功能：高级交互式搜索
# - 预览窗口常在，但内容需按 Ctrl-p 触发加载
# - 使用 Enter 或 Ctrl-o 打开仓库
# - j/k 导航，q/esc 退出
ghsi() {
  if [[ -z "$*" ]]; then
    echo "Usage: ghsi <search-term>"
    return 1
  fi

  # fzf 启动时，preview 命令是 'echo "Press Ctrl-p to load preview..."'
  # 这使得预览窗口一直存在，但只显示提示信息。
  gh search repos "$@" --limit 100 --json fullName --jq '.[].fullName' | \
  fzf --height=80% --reverse \
      --prompt="▶ " \
      --header="[ Enter/Ctrl-o: Open Repo ] [ Ctrl-p: Load Preview ] [ q/esc: Quit ]" \
      --preview-window 'right:60%:wrap' \
      --preview 'echo "Press Ctrl-p to load preview for {}..."' \
      --bind 'ctrl-p:change-preview(gh repo view {} | head -n 200)' \
      --bind 'ctrl-o:execute-silent(gh repo view --web {})' \
      --bind 'enter:execute-silent(gh repo view --web {})' \
      --bind 'q:abort' > /dev/null
}
