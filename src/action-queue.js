class TaskQueue {
  constructor() { this._items = []; }
  enqueue(item) { this._items.push(item); }
  dequeue()     { return this._items.shift(); }
  get size()    { return this._items.length; }
}

const taskQueue = new TaskQueue();
export default taskQueue