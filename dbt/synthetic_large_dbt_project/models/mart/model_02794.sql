{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02241') }},
        {{ ref('model_01914') }}
)
select id, 'model_02794' as name from sources
