{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00468') }},
        {{ ref('model_00146') }},
        {{ ref('model_00323') }}
)
select id, 'model_00872' as name from sources
