import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';

function Square(props) {
  return (
    <button className="square" onClick={props.onClick}>
      {props.value}
    </button>
  );
}

class Board extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      squares: Array(9).fill(null),
      xIsNext: true,
    };

    this.handleClick = this.handleClick.bind(this);
  }

  renderSquare(i) {
    return <Square value={this.state.squares[i]} onClick={() => this.handleClick(i)}/>;
  }

  handleClick(index) {
    const newSquares = this.state.squares.slice();
    newSquares[index] = this.state.xIsNext? "X" : "O";
    this.setState({
      squares: newSquares,
      xIsNext: !this.state.xIsNext,
    });
  }

  render() {
    const status = 'Next player: ' + (this.state.xIsNext ? "X" : "O");

    return (
      <div>
          <div className="status">{status}</div>
          <div className="board-row">
            {[0,1,2].map((i) => this.renderSquare(i))}
          </div>
          <div className="board-row">
            {[3,4,5].map((i) => this.renderSquare(i))}
          </div>
          <div className="board-row">
            {[6,7,8].map((i) => this.renderSquare(i))}
          </div>
      </div>
  );
  }
}

class Game extends React.Component {
  render() {
    return (
      <div className="game">
        <div className="game-board">
          <Board />
        </div>
        <div className="game-info">
          <div>{/* status */}</div>
          <ol>{/* TODO */}</ol>
        </div>
      </div>
    )
  }
}

ReactDOM.render(
  <Game />,
  document.getElementById('root')
);
