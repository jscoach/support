import React from 'react'
import PureRenderMixin from 'react-addons-pure-render-mixin'

/*
 * Subset of the SVG icon collection from GitHub
 */
let Icon = React.createClass({
  mixins: [PureRenderMixin],
  propTypes: {
    type: React.PropTypes.string.isRequired,
    size: React.PropTypes.oneOfType([
      React.PropTypes.string,
      React.PropTypes.number
    ]),
    style: React.PropTypes.object
  },
  getDefaultProps () {
    return {
      size: '1em'
    }
  },
  renderGraphic () {
    switch (this.props.type) {
      case 'help':
        return (
          <g><path d='M11 18h2v-2h-2v2zm1-16C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8
            8 3.59 8 8-3.59 8-8 8zm0-14c-2.21 0-4 1.79-4 4h2c0-1.1.9-2 2-2s2 .9 2 2c0 2-3 1.75-3 5h2c0-2.25 3-2.5 3-5 0-2.21-1.79-4-4-4z'/></g>
        )
      case 'github':
        return (
          <g><path d='m11.5 0c-6.351 0-11.5 5.05-11.5 11.278 0 4.984 3.295 9.21 7.865 10.701.575.103.785-.245.785-.542
            0-.268-.011-1.158-.016-2.1-2.891.517-3.632-.695-3.874-1.33-.124-.326-.683-1.327-1.177-1.592-.404-.216-.972-.732-.021-.743.908-.01
            1.558.822 1.763 1.162 1.032 1.713 2.693 1.225 3.347.936.105-.727.402-1.225.73-1.506-2.553-.285-5.238-1.253-5.238-5.574
            0-1.232.449-2.237 1.183-3.03-.117-.286-.513-1.434.114-2.986 0 0 .964-.303 3.163 1.156.917-.251 1.9-.375 2.878-.379.977.004
            1.961.129 2.879.381 2.194-1.461 3.16-1.156 3.16-1.156.629 1.554.233 2.7.115 2.985.737.79 1.182 1.795 1.182 3.03 0 4.333-2.69
            5.287-5.252 5.566.414.35.78 1.035.78 2.087 0 1.508-.015 2.723-.015 3.095 0 .3.209.651.792.541 4.567-1.494 7.859-5.72 7.859-10.701
            0-6.228-5.149-11.278-11.5-11.278'/></g>
        )
      case 'menu':
        return (
          <g><path d='m3 20h20v-2h-20v2m0-7h20v-2h-20v2m0-9v2h20v-2h-20'/></g>
        )
    }
  },
  render () {
    let styles = {
      fill: 'currentcolor',
      verticalAlign: '-0.15em',
      width: this.props.size, // CSS instead of the width attr to support non-pixel units
      height: this.props.size
    }
    return (
      <svg viewBox='0 0 24 24' preserveAspectRatio='xMidYMid meet' fit
        style={Object.assign(
          styles,
          this.props.style // This lets the parent pass custom styles
        )}>
          {this.renderGraphic()}
      </svg>
    )
  }
})

export default Icon
