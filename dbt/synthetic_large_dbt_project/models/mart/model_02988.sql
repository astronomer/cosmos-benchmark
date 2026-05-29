{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02041') }},
        {{ ref('model_01639') }},
        {{ ref('model_01917') }}
)
select id, 'model_02988' as name from sources
