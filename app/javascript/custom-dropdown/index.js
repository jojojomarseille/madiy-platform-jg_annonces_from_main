import $ from "jquery";
import 'daterangepicker/daterangepicker.js';
import 'daterangepicker/daterangepicker.css';

export function initDropdown()
{
  let x, i, j, selElmnt, a, b, c;
  /* Look for any elements with the class "custom-select": */
  x = document.getElementsByClassName("custom-select");
  for (i = 0; i < x.length; i++) {
    selElmnt = x[i].getElementsByTagName("select")[0];
    // d = x[i].getElementsByClassName("select")[0];
    /* For each element, create a new DIV that will act as the selected item: */
    const btn = document.createElement("DIV");
    btn.setAttribute("class", "btn-arrow");
    x[i].appendChild(btn);

    a = document.createElement("DIV");
    a.setAttribute("class", "select-selected");
    a.innerHTML = selElmnt.options[selElmnt.selectedIndex].innerHTML;
    x[i].appendChild(a);
    /* For each element, create a new DIV that will contain the option list: */
    b = document.createElement("DIV");
    b.setAttribute("class", "select-items select-hide");

    // b.appendChild('<div>Tous</div>');
    // c = document.createElement("DIV");
    // c.innerHTML = 'Tou(te)s';
    // b.appendChild(c);

    for (j = 0; j < selElmnt.length; j++) {
      /* For each option in the original select element,
      create a new DIV that will act as an option item: */
      c = document.createElement("DIV");
      c.innerHTML = selElmnt.options[j].innerHTML;
      c.addEventListener("click", function(e) {
        /* When an item is clicked, update the original select box,
        and the selected item: */
        var y, i, k, s, h;
        s = this.parentNode.parentNode.getElementsByTagName("select")[0];
        h = this.parentNode.previousSibling;
        for (i = 0; i < s.length; i++) {
          if (s.options[i].innerHTML == this.innerHTML) {
            s.selectedIndex = i;
            h.innerHTML = this.innerHTML;
            y = this.parentNode.getElementsByClassName("same-as-selected");
            for (k = 0; k < y.length; k++) {
              y[k].removeAttribute("class");
            }
            this.setAttribute("class", "same-as-selected");
            break;
          }
        }
        h.click();
        h.dispatchEvent(new CustomEvent("change"));
        const changeEvent = new Event('change');
        s.dispatchEvent(changeEvent)
        // h.trigger('change');
        // onChangeSelect(s);
      });
      b.appendChild(c);
    }
    x[i].appendChild(b);
    bindLink(a);
    bindButton(btn, a);
  }
}

function bindLink(a) {
  a.addEventListener("click", function(e) {
    /* When the select box is clicked, close any other select boxes,
    and open/close the current select box: */
    e.stopPropagation();
    closeAllSelect(this);
    this.nextSibling.classList.toggle("select-hide");
    this.classList.toggle("select-arrow-active");
  });
}

function bindButton(btn, a) {
  btn.addEventListener("click", function(e) {
    /* When the select box is clicked, close any other select boxes,
    and open/close the current select box: */
    e.stopPropagation();
    closeAllSelect(this);
    a.nextSibling.classList.toggle("select-hide");
    a.classList.toggle("select-arrow-active");
  });
}

function closeAllSelect(elmnt) {
  /* A function that will close all select boxes in the document,
  except the current select box: */
  var x, y, i, arrNo = [];
  x = document.getElementsByClassName("select-items");
  y = document.getElementsByClassName("select-selected");
  for (i = 0; i < y.length; i++) {
    if (elmnt == y[i]) {
      arrNo.push(i)
    } else {
      y[i].classList.remove("select-arrow-active");
    }
  }
  for (i = 0; i < x.length; i++) {
    if (arrNo.indexOf(i)) {
      x[i].classList.add("select-hide");
    }
  }
}

document.addEventListener("turbolinks:load", () => {
  initDropdown();

  /* If the user clicks anywhere outside the select box,
  then close all select boxes: */
  document.addEventListener("click", closeAllSelect);

  $('input[name="daterange"]').daterangepicker({
    opens: 'left',
    autoUpdateInput: false,
    autoApply:true,
    locale: {
      cancelLabel: 'Clear',
      format: "DD/MM/YYYY",
      applyLabel: "Sélectionner",
          cancelLabel: "Annuler",
          fromLabel: "De",
          toLabel: "à",
          weekLabel: "Sem",
          daysOfWeek: ["Di","Lu","Ma","Me","Je","Ve","Sa"],
          monthNames: ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"],
          firstDay:1,
    }
  });

  $('input[name="daterange"]').on('apply.daterangepicker', function(ev, picker) {
    $(this).val(picker.startDate.format('DD/MM/YYYY') + ' - ' + picker.endDate.format('DD/MM/YYYY'));
    $(this).trigger('change');
    this.dispatchEvent(new CustomEvent("daterangepicked", { detail: { from: picker.startDate, to: picker.endDate }}))
  });
})
