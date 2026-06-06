{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00939') }},
        {{ ref('model_01165') }},
        {{ ref('model_01467') }}
)
select id, 'model_01783' as name from sources
