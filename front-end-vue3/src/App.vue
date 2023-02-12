<script setup>
// import { RouterLink, RouterView } from 'vue-router';
// import HelloWorld from './components/HelloWorld.vue';
import { computed, ref } from 'vue';
import axios from 'axios';


// const msg_input = ref('Hello World!');
// const kw_search = ref('');

const proxyscheme = ref('brook');
const options = ref(['brook', 'v2ray']);
const cur_status = ref('disconnected');
const conn_status = ref({s0: 'disconnected', s1: 'connected'});
const connections = ref({
  brook: {serverip: '1.1.1.1',
          serverport: '1111',
          connuid: 'password'},
  v2ray: {serverip: '1.1.1.1',
          serverport: '2222',
          connuid: 'uuid'}
});
const uxsettings = {
  brook: {
    bg: 'green-3',
    tips: '连接密码'
  },
  v2ray: {
    bg: 'cyan',
    tips: '客户端UID'
  }
}
const connstatustips = {
  connected: {
    btn: '断开',
    msg: '已连接至服务器',
    style: 'color: green'
  },
  disconnected: {
    btn: '连接',
    msg: '已断开',
    style: 'color: red'
  }
}

// let passoridtips = computed(() => {
//   if (proxyscheme.value == "brook") {
//     return "连接密码"
//   } else {
//     return "客户端UID"
//   }
// });



function sendRequest() {
  if (cur_status.value == conn_status.value.s0) {
    startReq();
  } else {
    stopReq();
  }
};

function startReq(index) {
  // 请求连接
  const url = "/start";
  console.log(proxyscheme.value);
  console.log(connections.value[proxyscheme.value]);
  axios.post(url, {
          scheme: proxyscheme.value,
          serverip: connections.value[proxyscheme.value].serverip,
          serverport: connections.value[proxyscheme.value].serverport,
          connuid: connections.value[proxyscheme.value].connuid
        })
        .then(function (response) {
          let result = response.data;
          if ( result == 'True' ) {
            cur_status.value = conn_status.value.s1
          }
        })
        .catch(function (error) {
          console.log(error);
        });
};

function stopReq(index) {
  // 请求连接
  const url = "/stop";
  axios.post(url, {
          scheme: proxyscheme.value
        })
        .then(function (response) {
          let result = response.data;
          if ( result == 'True' ) {
            cur_status.value = conn_status.value.s0
          }
        })
        .catch(function (error) {
          console.log(error);
        });
};
</script>

<template>
    <div class="fit Flex wrap justify-center items-center content-center" style="vertical-align: top; margin: auto;">
      <!-- <HelloWorld :msg=msg_input /> -->
      <div class="q-pa-md">
        <q-form class="q-gutter-md">
          <q-select color="purple-8" :bg-color=uxsettings[proxyscheme].bg outlined v-model="proxyscheme" :options="options" label="代理类型" />
          <q-input filled v-model="connections[proxyscheme].serverip" label="服务器IP" :dense="dense" />
          <q-input filled v-model="connections[proxyscheme].serverport" label="服务器端口号" :dense="dense" />
          <q-input filled v-model="connections[proxyscheme].connuid" :label=uxsettings[proxyscheme].tips :dense="dense" />
          <q-btn color="primary" :label=connstatustips[cur_status].btn @click="sendRequest" />
          <h4 :style="connstatustips[cur_status].style">当前状态: {{ connstatustips[cur_status].msg }}</h4>
        </q-form>
      </div>
    </div>
  
  <!-- <RouterView /> -->
</template>

<style scoped>

</style>
