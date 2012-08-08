function switchmodTag(menus,divs,openClass,closeClass) {
    
        var _this = this;
        if(menus.length != divs.length)
        {
            alert("菜单层数量和内容层数量不一样!");
            return false;
        }
        for(var i = 0 ; i < menus.length ; i++)
        {
            document.getElementById(menus[i]).value = i;
            document.getElementById(menus[i]).onmouseover = function()
            { //如果想把效果变成点击切换，将此行onmouseover 改成onclick即可。
                for(var j = 0 ; j < menus.length ; j++)
                {
                   document.getElementById(menus[j]).className = closeClass;
                   document.getElementById(divs[j]).style.display = "none";
                }
                document.getElementById(menus[this.value]).className = openClass;
                document.getElementById(divs[this.value]).style.display = "block";
            }
        }
    }
