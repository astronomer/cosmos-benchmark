{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01886') }},
        {{ ref('model_01784') }}
)
select id, 'model_02527' as name from sources
