const axios = require("axios");

describe("Integration tests", () => {
  test("Node -> Python analyze endpoint", async () => {
    const res = await axios.post("http://localhost:3000/analyze", {
      script: "console.log('test');"
    });
    expect(res.data).toHaveProperty("length");
    expect(res.data.message).toMatch(/analyzed/i);
  });

  test("Node -> Dart analyze endpoint", async () => {
    const res = await axios.post("http://localhost:3000/analyze-dart", {
      script: "print('test');"
    });
    expect(res.data).toMatch(/analyzed/i);
  });
});
