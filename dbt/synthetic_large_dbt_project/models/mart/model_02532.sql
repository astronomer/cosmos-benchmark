{{ config(materialized='view') }}

with sources as (
    select 1 as id
    from {{ ref('model_01705') }},
        {{ ref('model_01630') }}
)
select id, 'model_02532' as name from sources
