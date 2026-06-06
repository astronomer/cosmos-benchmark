{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00600') }},
        {{ ref('model_00564') }}
)
select id, 'model_00852' as name from sources
