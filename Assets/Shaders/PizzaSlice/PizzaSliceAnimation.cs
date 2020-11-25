using UnityEngine;

public class PizzaSliceAnimation : MonoBehaviour
{
    private static readonly int propFillAmount = Shader.PropertyToID("_FillAmount");
    private static readonly int propBaseColor = Shader.PropertyToID("_BaseColor");

    public float speed = 0.5f;
    public AnimationCurve easing = AnimationCurve.EaseInOut(0, 0, 1, 1);
    [Tooltip("The minimum value (of the HSV) color to randomly generate.")]
    [Range(0f, 1f)] public float minColorValue = 0.7f;
    [Tooltip("The minimum saturation (of the HSV) color to randomly generate.")]
    [Range(0f, 1f)] public float minColorSaturation = 0.5f;

    private new Renderer renderer;
    private int lastCycleColorChanged = -1;


    private void Awake()
    {
        renderer = GetComponent<Renderer>();

        if (renderer == null)
        {
            enabled = false;
            Debug.LogWarning($"No renderer attached to the GameObject '{name}'. Cannot animate pizza slice.");
        }
    }

    private void Update()
    {
        float time = (Time.time + 2) * speed;
        int cycleIndex = Mathf.FloorToInt((time + 1) * 0.5f);

        if (cycleIndex != lastCycleColorChanged)
        {
            renderer.material.SetColor(propBaseColor, RandomColor());
            lastCycleColorChanged = cycleIndex;
        }

        float fillAmount = Mathf.Abs(time % 2 - 1);
        fillAmount = easing.Evaluate(fillAmount);

        renderer.material.SetFloat(propFillAmount, fillAmount);
    }

    private Color RandomColor()
    {
        return Random.ColorHSV(0, 1, minColorSaturation, 1, minColorValue, 1, 1, 1);
    }
}
