{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00420') }},
        {{ ref('model_00270') }}
)
select id, 'model_00841' as name from sources
