webpackJsonp([1],{CLxe:function(e,t){},EgzA:function(e,t){},KmD1:function(e,t){},NHnr:function(e,t,r){"use strict";Object.defineProperty(t,"__esModule",{value:!0});var n=r("7+uW"),a=r("mtWM"),i=r.n(a),o=r("7nRM"),s=r.n(o),c={name:"create-component",components:{},props:[],data:function(){var e;return{reseau:"",station:"",traffic:"",correspondance:"",ville:"",arrondissement:"",contextTrafficServiceUrl:"http://54.38.186.137:9080/StationDemoWeb/station",errors:(e={},s()(e),e),displayArron:!1,listeReseauxDispo:[{key:"",value:"-------------"},{key:"Metro",value:"Metro"},{key:"RER",value:"RER"}]}},computed:{},mounted:function(){},methods:{sub:function(e){var t=this;i.a.put(this.contextTrafficServiceUrl+"/insertStation",{reseau:this.reseau,station:this.station,traffic:this.traffic,listCorrespondance:this.correspondance.split(","),ville:this.ville,arrondissement:this.arrondissement},{headers:{"Content-Type":"application/json"}}).then(function(e){var r=e.data;r.success?(alert("The station has been inserted with success"),t.$router.push("/")):(t.errors.length=0,t.errors=r.errors)}).catch(function(e){t.errors.push(e)}),e.preventDefault()},changeVille:function(){var e=this.ville.toUpperCase();this.displayArron="PARIS"==e||"LYON"==e||"TOULOUSE"==e||"MARSEILLE"==e}}},l={render:function(){var e=this,t=e.$createElement,r=e._self._c||t;return r("section",{staticClass:"create-component"},[r("h1",[e._v("Create Station")]),e._v(" "),r("br"),e._v(" "),r("br"),e._v(" "),r("center",[null!=e.errors&&0!=e.errors.length?r("div",[r("TABLE",{attrs:{BORDER:"0"}},e._l(e.errors,function(t){return r("tr",[r("td",{staticClass:"tdmessagelogin"},[r("span",{staticClass:"messageerreur"},[e._v(" "+e._s(t)+" ")])])])})),e._v(" "),r("br")],1):e._e(),e._v(" "),r("br"),e._v(" "),r("form",{attrs:{method:"post"},on:{submit:e.sub}},[r("table",[r("tr",[r("td",[e._v("Reseau       : ")]),e._v(" "),r("td",[r("select",{directives:[{name:"model",rawName:"v-model",value:e.reseau,expression:"reseau"}],attrs:{required:""},on:{change:function(t){var r=Array.prototype.filter.call(t.target.options,function(e){return e.selected}).map(function(e){return"_value"in e?e._value:e.value});e.reseau=t.target.multiple?r:r[0]}}},e._l(e.listeReseauxDispo,function(t){return r("option",{domProps:{value:t.key}},[e._v(e._s(t.value))])}))])]),e._v(" "),r("tr",[r("td",[e._v("Station         : ")]),e._v(" "),r("td",[r("input",{directives:[{name:"model",rawName:"v-model.trim",value:e.station,expression:"station",modifiers:{trim:!0}}],attrs:{required:""},domProps:{value:e.station},on:{input:function(t){t.target.composing||(e.station=t.target.value.trim())},blur:function(t){e.$forceUpdate()}}})])]),e._v(" "),r("tr",[r("td",[e._v("Traffic         : ")]),e._v(" "),r("td",[r("input",{directives:[{name:"model",rawName:"v-model",value:e.traffic,expression:"traffic"}],attrs:{type:"number",required:""},domProps:{value:e.traffic},on:{input:function(t){t.target.composing||(e.traffic=t.target.value)}}})])]),e._v(" "),r("tr",[r("td",[e._v("Correspondan  : ")]),e._v(" "),r("td",[r("input",{directives:[{name:"model",rawName:"v-model",value:e.correspondance,expression:"correspondance"}],domProps:{value:e.correspondance},on:{input:function(t){t.target.composing||(e.correspondance=t.target.value)}}})])]),e._v(" "),r("tr",[r("td",[e._v("Ville           : ")]),e._v(" "),r("td",[r("input",{directives:[{name:"model",rawName:"v-model.trim",value:e.ville,expression:"ville",modifiers:{trim:!0}}],attrs:{minlength:"3",maxlength:"30",required:""},domProps:{value:e.ville},on:{change:e.changeVille,input:function(t){t.target.composing||(e.ville=t.target.value.trim())},blur:function(t){e.$forceUpdate()}}})])]),e._v(" "),r("tr",[r("td",[e.displayArron?r("div",[e._v("Arrondissement  : ")]):e._e()]),e._v(" "),r("td",[e.displayArron?r("div",[r("input",{directives:[{name:"model",rawName:"v-model.trim",value:e.arrondissement,expression:"arrondissement",modifiers:{trim:!0}}],attrs:{type:"number"},domProps:{value:e.arrondissement},on:{input:function(t){t.target.composing||(e.arrondissement=t.target.value.trim())},blur:function(t){e.$forceUpdate()}}})]):e._e()])])]),e._v(" "),r("br"),e._v(" "),r("br"),e._v(" "),r("button",{attrs:{type:"submit"}},[e._v("Create")])]),e._v(" "),r("br"),e._v(" "),r("br"),e._v(" "),r("router-link",{attrs:{to:{path:"/"}}},[e._v("Back")])],1)],1)},staticRenderFns:[]};var u=r("VU/8")(c,l,!1,function(e){r("EgzA")},"data-v-6f789c08",null).exports,v={name:"search-component",components:{CreateComponent:u},props:[],data:function(){return{reseau:"",station:"",trafficMin:"",trafficMax:"",ville:"",contextTrafficServiceUrl:"http://54.38.186.137:9080/StationDemoWeb/station",resultSearchs:[],NUMBER_PAGE_MAX:25,messages:[],displayedColumns:[{label:"ID",field:"id",hidden:!0},{label:"Station",field:"station"},{label:"Reseau",field:"reseau"},{label:"Traffic",field:"traffic",type:"number"},{label:"Correspond",field:"listCorrespondance"},{label:"Ville",field:"ville"},{label:"Arrond",field:"arrondissement",type:"number"}],listeReseauxDispo:[{key:"",value:"-------------"},{key:"Metro",value:"Metro"},{key:"RER",value:"RER"}],onClickFn:function(e,t){this.$router.push("/selectStation/"+e.id)}}},computed:{},mounted:function(){},methods:{sub:function(e){var t=this;i.a.post(this.contextTrafficServiceUrl+"/findStationsByCrit",{reseau:this.reseau,station:this.station,trafficMin:this.trafficMin,trafficMax:this.trafficMax,ville:this.ville,numberMaxElements:3e3,page:1},{headers:{"Content-Type":"application/json"}}).then(function(e){var r=e.data;t.resultSearchs=r,t.messages.length=0,null!=t.resultSearchs&&100===t.resultSearchs.length&&t.messages.push("The search return too much elements.")}).catch(function(e){t.errors.push(e)}),e.preventDefault()},createComponent:function(e){this.$router.push("/createStation")}}},d={render:function(){var e=this,t=e.$createElement,r=e._self._c||t;return r("section",{staticClass:"search-component"},[r("h1",[e._v("Recherche station")]),e._v(" "),r("br"),e._v(" "),r("br"),e._v(" "),r("center",[null!=e.messages&&0!=e.messages.length?r("div",[r("TABLE",{attrs:{BORDER:"0"}},e._l(e.messages,function(t){return r("tr",[r("td",[r("span",{staticClass:"messageInfo"},[e._v(" "+e._s(t)+" ")])])])})),e._v(" "),r("br")],1):e._e()]),e._v(" "),r("br"),e._v(" "),r("center",[r("form",{attrs:{action:"#",method:"post"},on:{submit:e.sub}},[r("table",[r("tr",[r("td",[e._v("Reseau       : ")]),e._v(" "),r("select",{directives:[{name:"model",rawName:"v-model",value:e.reseau,expression:"reseau"}],on:{change:function(t){var r=Array.prototype.filter.call(t.target.options,function(e){return e.selected}).map(function(e){return"_value"in e?e._value:e.value});e.reseau=t.target.multiple?r:r[0]}}},e._l(e.listeReseauxDispo,function(t){return r("option",{domProps:{value:t.key}},[e._v(e._s(t.value))])}))]),e._v(" "),r("tr",[r("td",[e._v("Station      : ")]),e._v(" "),r("input",{directives:[{name:"model",rawName:"v-model.trim",value:e.station,expression:"station",modifiers:{trim:!0}}],domProps:{value:e.station},on:{input:function(t){t.target.composing||(e.station=t.target.value.trim())},blur:function(t){e.$forceUpdate()}}})]),e._v(" "),r("tr",[r("td",[e._v("Traffic Min : ")]),e._v(" "),r("input",{directives:[{name:"model",rawName:"v-model",value:e.trafficMin,expression:"trafficMin"}],attrs:{type:"number"},domProps:{value:e.trafficMin},on:{input:function(t){t.target.composing||(e.trafficMin=t.target.value)}}})]),e._v(" "),r("tr",[r("td",[e._v("Traffic Max : ")]),e._v(" "),r("input",{directives:[{name:"model",rawName:"v-model",value:e.trafficMax,expression:"trafficMax"}],attrs:{type:"number"},domProps:{value:e.trafficMax},on:{input:function(t){t.target.composing||(e.trafficMax=t.target.value)}}})]),e._v(" "),r("tr",[r("td",[e._v("Ville        : ")]),e._v(" "),r("input",{directives:[{name:"model",rawName:"v-model.trim",value:e.ville,expression:"ville",modifiers:{trim:!0}}],attrs:{minlength:"3",maxlength:"30"},domProps:{value:e.ville},on:{input:function(t){t.target.composing||(e.ville=t.target.value.trim())},blur:function(t){e.$forceUpdate()}}})])]),e._v(" "),r("br"),e._v(" "),r("br"),e._v(" "),r("button",{attrs:{type:"submit"}},[e._v("Search")]),e._v(" "),r("br"),e._v(" "),r("br"),e._v(" "),r("br"),e._v(" "),r("vue-good-table",{attrs:{title:"",columns:e.displayedColumns,rows:e.resultSearchs,paginate:!0,onClick:e.onClickFn,perPage:20}}),e._v(" "),r("br"),e._v(" "),r("br")],1),e._v(" "),r("button",{on:{click:function(t){e.createComponent("createTest")}}},[e._v("Create")]),e._v(" "),r("br")])],1)},staticRenderFns:[]};var p=r("VU/8")(v,d,!1,function(e){r("vWTo")},"data-v-43d2dffc",null).exports,m={name:"App",components:{SearchComponent:p},data:function(){return{message:"Test"}},methods:{},computed:{}},f={render:function(){var e=this.$createElement,t=this._self._c||e;return t("div",{attrs:{id:"app"}},[t("router-view")],1)},staticRenderFns:[]};var _=r("VU/8")(m,f,!1,function(e){r("CLxe")},null,null).exports,h=r("/ocq"),b={name:"select-component",components:{},props:[],data:function(){return{test:"aaaa",contextTrafficServiceUrl:"http://54.38.186.137:9080/StationDemoWeb/station",id:0,reseau:"",station:"",traffic:0,correspondance:"",ville:"",arrondissement:0,displayArron:!0}},computed:{},mounted:function(){this.id=this.$route.params.id,this.selectStation()},methods:{selectStation:function(e){var t=this,r="/findStationById/"+this.id;i.a.get(this.contextTrafficServiceUrl+r,{},{headers:{"Content-Type":"application/x-www-form-urlencoded"}}).then(function(e){var r=e.data;t.id=r.id,t.reseau=r.reseau,t.station=r.station,t.traffic=r.traffic,null!=r.listCorrespondance&&(t.correspondance=r.listCorrespondance.toString()),t.ville=r.ville,t.arrondissement=r.arrondissement}).catch(function(e){t.errors.push(e)})},sub:function(e){var t=this,r="?newTraffic="+this.traffic+"&newCorr=";null!=this.correspondance&&""!=this.correspondance&&(r+=this.correspondance.split(",")),i.a.patch(this.contextTrafficServiceUrl+"/updateStation/"+this.id+r,{},{headers:{"Content-Type":"application/x-www-form-urlencoded"}}).then(function(e){var r=e.data;if(r.success)window.alert("The station "+t.station+" has been updated  with success"),t.$router.push("/");else{var n=r.errors[0];window.alert("Error --\x3e "+n)}}).catch(function(e){t.errors.push(e)}),e.preventDefault()},deleteStation:function(){var e=this;confirm("Are you sure to delete  the station '"+this.station+"'?")&&i.a.delete(this.contextTrafficServiceUrl+"/deleteStation/"+this.id,{},{headers:{"Content-Type":"application/json"}}).then(function(t){var r=t.data;if(r.success)window.alert("The station has been delete with success"),e.$router.push("/");else{var n=r.errors[0];window.alert("Error --\x3e "+n)}}).catch(function(t){e.errors.push(t)})}}},g={render:function(){var e=this,t=e.$createElement,r=e._self._c||t;return r("section",{staticClass:"select-component"},[r("h1",[e._v("Select Station")]),e._v(" "),r("br"),e._v(" "),r("br"),e._v(" "),r("center",[r("form",{attrs:{method:"post"},on:{submit:e.sub}},[r("table",[r("tr",[r("td",[e._v("Reseau       : ")]),e._v(" "),r("td",[e._v(e._s(e.reseau))])]),e._v(" "),r("tr",[r("td",[e._v("Station         : ")]),e._v(" "),r("td",[e._v(e._s(e.station))])]),e._v(" "),r("tr",[r("td",[e._v("Traffic         : ")]),e._v(" "),r("td",[r("input",{directives:[{name:"model",rawName:"v-model",value:e.traffic,expression:"traffic"}],attrs:{type:"number",required:""},domProps:{value:e.traffic},on:{input:function(t){t.target.composing||(e.traffic=t.target.value)}}})])]),e._v(" "),r("tr",[r("td",[e._v("Correspondan  : ")]),e._v(" "),r("td",[r("input",{directives:[{name:"model",rawName:"v-model",value:e.correspondance,expression:"correspondance"}],domProps:{value:e.correspondance},on:{input:function(t){t.target.composing||(e.correspondance=t.target.value)}}})])]),e._v(" "),r("tr",[r("td",[e._v("Ville           : ")]),e._v(" "),r("td",[e._v(e._s(e.ville))])]),e._v(" "),r("tr",[r("td",[e.displayArron?r("div",[e._v("Arrondissement  : ")]):e._e()]),e._v(" "),r("td",[e.displayArron?r("div",[e._v(e._s(e.reseau))]):e._e()])])]),e._v(" "),r("br"),e._v(" "),r("br"),e._v(" "),r("table",[r("tr",[r("td",{staticClass:"buttonSelect"}),e._v(" "),r("td",{staticClass:"buttonSelect"},[r("button",{attrs:{type:"submit"}},[e._v("Update")])])])])]),e._v(" "),r("br"),e._v(" "),r("table",[r("tr",[r("td",{staticClass:"buttonSelect"}),e._v(" "),r("td",{staticClass:"buttonSelect"},[r("button",{on:{click:function(t){e.deleteStation()}}},[e._v("Delete")])])])])])],1)},staticRenderFns:[]};var x=r("VU/8")(b,g,!1,function(e){r("KmD1")},"data-v-0cb5b1fc",null).exports,S=r("uGpI"),y=r.n(S);n.a.use(h.a),n.a.use(y.a);var C=new h.a({routes:[{path:"/",component:p},{path:"/createStation",component:u},{path:"/selectStation/:id",component:x}]});n.a.config.productionTip=!1,new n.a({el:"#app",router:C,components:{App:_},template:"<App/>"})},vWTo:function(e,t){}},["NHnr"]);
//# sourceMappingURL=app.6d4e02afba11b488c3b0.js.map