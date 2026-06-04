{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01375') }},
        {{ ref('model_00900') }},
        {{ ref('model_01467') }}
)
select id, 'model_01538' as name from sources
