{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00998') }},
        {{ ref('model_01480') }},
        {{ ref('model_01198') }}
)
select id, 'model_01684' as name from sources
