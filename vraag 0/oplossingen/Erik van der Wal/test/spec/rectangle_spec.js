describe("Rectangle", function() {

  it("should detect when rectangles intersect", function() {
    r1 = createRectObject(00, 10, 100, 50);
    r2 = createRectObject(90, 00, 100, 50);
    expect(rectIntersects(r1, r2)).toBe(true, "Rectangles intersect, got wrong result");

    r1 = createRectObject(100, 00, 100, 50);
    r2 = createRectObject(60, 30, 100, 50);
    expect(rectIntersects(r1, r2)).toBe(true, "Rectangles intersect, got wrong result");

    r1 = createRectObject(60, 50, 100, 50);
    r2 = createRectObject(60, 10, 100, 50);
    expect(rectIntersects(r1, r2)).toBe(true, "Rectangles intersect, got wrong result");
  });

  it("should detect when rectangles don't intersect", function() {
    r1 = createRectObject(00, 00, 100, 50);
    r2 = createRectObject(100, 00, 100, 50);
    expect(rectIntersects(r1, r2)).toBe(false, "Rectangles don't intersect, got wrong result");

    r1 = createRectObject(100, 50, 100, 50);
    r2 = createRectObject(30, 00, 100, 50);
    expect(rectIntersects(r1, r2)).toBe(false, "Rectangles don't intersect, got wrong result");

    r1 = createRectObject(200, 00, 100, 50);
    r2 = createRectObject(00, 00, 200, 50);
    expect(rectIntersects(r1, r2)).toBe(false, "Rectangles don't intersect, got wrong result");
  });

});