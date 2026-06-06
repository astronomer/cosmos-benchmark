{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_00949') }},
        {{ ref('model_01396') }}
)
select id, 'model_01630' as name from sources
