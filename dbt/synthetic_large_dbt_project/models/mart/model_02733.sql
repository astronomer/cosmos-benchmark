{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_02048') }},
        {{ ref('model_01774') }},
        {{ ref('model_01630') }}
)
select id, 'model_02733' as name from sources
