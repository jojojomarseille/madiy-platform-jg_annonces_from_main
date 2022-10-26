import { gsap, TweenLite } from 'gsap';
import Draggable from 'gsap/Draggable';

gsap.registerPlugin(Draggable);

let minValue = 15;
let maxValue = 181;

let startMin = 30;
let startMax = 120;

let value1 = startMin;
let value2 = startMax;

let min;
let max;
let input;
let initialised = false;

let container;
let containerX;
let containerWidth;
let parent;

let knobWidth;
let knobOffset;

let knob1;
let knob2;

document.addEventListener("turbolinks:load", () =>  {
  if($("#slider-container").length)
  {
    min = $("#min");
    max = $("#max");
    input = $("#tarifrange");

    container = $("#slider-container");
    parent = container.parent();
    containerX = container.offset().left;
    containerWidth = container.width();

    knobWidth = $(".knob").outerWidth();
    knobOffset = knobWidth / 2;

    $('#tarifrange').on('click', function(e)
    {
      parent.show();
      e.stopPropagation();
    });
    document.addEventListener("click", hide);

    Draggable.create(".knob", {
      type: "x",
      bounds: { left: -knobOffset, width: containerWidth + knobWidth },
      cursor: "pointer",
      onDrag : updateRange
    });

    Draggable.create(container, {
      bounds: container,
      cursor: "pointer",
      onPress: setKnob
    });

    knob1 = Draggable.get("#knob1");
    knob2 = Draggable.get("#knob2");

    init(startMin, startMax);
  }
});

///////////

function init(start1, start2)
{
  TweenLite.set(knob1.target, { x: getPosition(start1) });
  TweenLite.set(knob2.target, { x: getPosition(start2) });
  knob1.update();
  knob2.update();
  updateRange();
  parent.addClass('init');
  input.val('Tarifs');
  initialised = true;
}

function hide()
{
  parent.hide();
}

function getValue(position)
{
  let ratio = position / containerWidth;
  let value = ((maxValue - minValue) * ratio) + minValue;

  return value;
}

function getPosition(value)
{
  let ratio = (value - minValue) / (maxValue - minValue);
  let position = (ratio * containerWidth) - knobOffset;

  return position;
}

function setKnob(event)
{
  if (event.target === knob1.target ||
      event.target === knob2.target) {
      return
  };

  mouseX = this.pointerX - containerX;

  let d1 = Math.abs(mouseX - knob1.x);
  let d2 = Math.abs(mouseX - knob2.x);

  // Select the closest knob
  let knob = d1 > d2 ? knob2 : knob1;

  TweenLite.set(knob.target, {
    x: mouseX - knobOffset,
    onComplete: function() {
      knob.startDrag(event);
  }});

  updateRange();
}

function getRange(knob)
{
  let range = knob.x + knobOffset;

  range = range < 1
    ? 0 : range > containerWidth
      ? containerWidth : range;

  return range;
}

function updateRange ()
{
  let range1 = getRange(knob1);
  let range2 = getRange(knob2);

  value1 = Math.round(getValue(range1));
  value2 = Math.round(getValue(range2));

  if(container.parent().css('display') != 'none')
  {
    if(range1 < range2)
    {
      TweenLite.set('.range', { x: range1, width: range2 - range1 });
      min.html(value1+'€');
      max.html(value2+'€');
      if(initialised)
      {
        input.val('de '+value1+'€ à '+value2+'€');
        input.trigger('change');
        const customEvent = new CustomEvent("priced", { detail: { from: value1 * 100, to: value2 * 100 } })
        input[0].dispatchEvent(customEvent)
      }

    }
    else
    {
      TweenLite.set('.range', { x: range2, width: range1 - range2 });
      min.html(value2+'€');
      max.html(value1+'€');
      if(initialised)
      {
        input.val('de '+value2+'€ à '+value1+'€');
        input.trigger('change');
        const customEvent = new CustomEvent("priced", { detail: { from: value1 * 100, to: value2 * 100 } })
        input[0].dispatchEvent(customEvent)
      }
    }
  }
}
