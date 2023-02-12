"""
启动一个后端flask服务, 通过调用shell脚本, 启动proxy client或者停止proxy client
"""
from flask import Flask, request
import os
# import functools

app = Flask(__name__)
TOGOOGLE_SHELL_PATH = "/opt/togoogle.sh"

def run_cmd(cmd):
    """执行系统命令"""
    r = os.popen(cmd)
    return r.read().strip().split('\n')

def is_process_running(process_name):
    """判断某个进程是否在运行"""
    ps_list = run_cmd(f"ps -ef|grep {process_name}")
    ps_list = list(filter(lambda s: f"grep {process_name}" not in s, ps_list))
    return len(ps_list)>0

@app.route('/')
def hello():
    """测试服务是否正常"""
    return 'Welcome to Flask HelloWorld!'

@app.route("/start", methods=['POST'])
def start_proxy():
    """启动proxy连接"""
    jsonbody = request.get_json()
    scheme = jsonbody.get("scheme").lower()
    serverip = jsonbody.get("serverip")
    serverport = jsonbody.get("serverport")
    password = jsonbody.get("connuid")

    os.environ['TOGOOGLE_WHO'] = scheme
    os.environ['TOGOOGLE_SERVERIP'] = serverip
    os.environ['TOGOOGLE_SERVERPORT'] = serverport
    os.environ['TOGOOGLE_PASSWORD'] = password

    if is_process_running(scheme):
        # 如果已经在运行, 先停止
        os.popen(f"{TOGOOGLE_SHELL_PATH} stop {scheme}")
    
    os.popen(f"{TOGOOGLE_SHELL_PATH} start {scheme}")
    return str(is_process_running(scheme))


@app.route("/stop", methods=['POST'])
def stop_proxy():
    """停止proxy连接"""
    jsonbody = request.get_json()
    scheme = jsonbody.get("scheme").lower()
    if is_process_running(scheme):
        os.popen(f"{TOGOOGLE_SHELL_PATH} stop {scheme}")
    return str(not is_process_running(scheme))

if __name__ == "__main__":
    """主函数入口"""
    app.run(host='0.0.0.0', port=80, debug=False)
