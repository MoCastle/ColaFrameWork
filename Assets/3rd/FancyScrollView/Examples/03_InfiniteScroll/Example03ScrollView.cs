﻿//# FancyScrollView

//A scrollview component that can implement highly flexible animation.
//It also supports infinite scrolling.
//This library is free and opensource on GitHub.More info, supports and sourcecodes, see[https://github.com/setchi/FancyScrollView](https://github.com/setchi/FancyScrollView)

//## License
//MIT

using System.Collections.Generic;
using UnityEngine;

namespace FancyScrollView
{
    public class Example03ScrollView : FancyScrollView<Example03CellDto, Example03ScrollViewContext>
    {
        [SerializeField]
        ScrollPositionController scrollPositionController;

        void Awake()
        {
            scrollPositionController.OnUpdatePosition(p => UpdatePosition(p));
            SetContext(new Example03ScrollViewContext { OnPressedCell = OnPressedCell });
        }

        public void UpdateData(List<Example03CellDto> data)
        {
            cellData = data;
            scrollPositionController.SetDataCount(cellData.Count);
            UpdateContents();
        }

        void OnPressedCell(Example03ScrollViewCell cell)
        {
            scrollPositionController.ScrollTo(cell.DataIndex, 0.4f);
            Context.SelectedIndex = cell.DataIndex;
            UpdateContents();
        }
    }
}
