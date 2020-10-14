$("body").html(function(_, html) {
        return  html.replace(/(–.)/g, '<span class="nobreak">$1</span>')
});