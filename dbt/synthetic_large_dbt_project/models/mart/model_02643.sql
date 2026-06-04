{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02137') }},
        {{ ref('model_01788') }},
        {{ ref('model_01772') }}
)
select id, 'model_02643' as name from sources
