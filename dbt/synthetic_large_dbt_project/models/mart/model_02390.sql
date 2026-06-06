{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01589') }},
        {{ ref('model_02087') }},
        {{ ref('model_01979') }}
)
select id, 'model_02390' as name from sources
